$LOAD_PATH << '../'
require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  test "Name, title, descrpiption and active are mandatory" do
    doc = build :document

    assert_required doc, :name, :title, :description, :active, :year

    assert_nothing_raised { doc.save! }
  end

  test "Name has to be short (<=15 chars)" do
    doc = build :document
    
    assert_max_length doc, name: 15
  end

  test "Year is between 1900 and 2025" do
    doc = build :document
    
    doc.year = 1899
    assert doc.invalid?
    doc.year = 2026
    assert doc.invalid?
    doc.year = 1900
    assert doc.valid?
    doc.year = 2025
    assert doc.valid?
  end

  test "Only one can be active for each name" do
    doc = build :document

    assert_nothing_raised do
      doc.active = true
      doc.save!
    end

    # Create mode
    same_name_doc = build :document, name: doc.name

    same_name_doc.active = true
    assert same_name_doc.invalid?

    same_name_doc.active = false
    assert same_name_doc.valid?

    # Update mode
    same_name_doc.save!
    assert_raise(ActiveRecord::RecordInvalid) do
      same_name_doc.active = true
      same_name_doc.save!
    end
  end

  test "Many inactive drafts for each name is fine" do
    doc = create :document, active: true

    assert_nothing_raised do
      3.times do
        doc = create :document, active: false, name: doc.name
        assert doc.valid?
      end
    end
  end

  test "Director URL needs to be a URL" do
    doc = build :document, director: "Director"

    doc.director_url = ""
    assert doc.valid?
    doc.director_url = "http://www.google.com/"
    assert doc.valid?

    doc.director_url = "htp://www.google.com/"
    assert doc.invalid?
  end

  test "Director URL needs a director" do
    doc = build :document, director_url: "http://www.facebook.com"
    
    doc.director = nil
    assert doc.invalid?
    doc.director = "Mark Zuckerberg"
    assert doc.valid?

  end

  test "sheet method eagerly loads all you need to display on a doc sheet" do
    create :document_sheet, name: 'doc', active: true

    assos = [ :checks, :reviews, :themes ]

    doc = Document.where(name: 'doc').first
    assos.each { |a| assert !doc.association(a).loaded?, "Basic requests don't fetch the #{a}." }

    sheet = Document.sheet('doc')
    assos.each do |a|
      assert sheet.association(a).loaded?, "sheet eagerly fetches #{a} for given name."
      assert !sheet.send(a).blank?,        "sheet loaded #{a} is not blank."
    end

    id = sheet.id
    id_sheet = Document.sheet(id)
    assos.each do |a|
      assert sheet.association(a).loaded?, "sheet does the job with id too (#{a})."
      assert !sheet.send(a).blank?,        "sheet loaded by id #{a} is not blank."
    end

    assert_nothing_raised do
      assert Document.sheet('wontwork').nil?, "sheet returns nil when no ID/name matches"
    end

    create :document, name: 'doc', active: false
    assert_equal true, sheet.active,                         "sheet fetches the active version by default"
    assert_equal false, Document.sheet('doc', false).active, "sheet can fetch the draft version if asked"
  end

  test "to_s returns the doc's name" do
    doc = build :document
    assert_equal "#{doc}", doc.name
  end

  test "Document can have an author" do
    author = build :user, login: 'author'
    doc    = build :document, author: author

    assert_equal User, doc.author.class
    assert_equal 'author', doc.author.login
    assert doc.is_a? Authored
  end

  test "each_line applies a block to each check, review and option of the sheet" do
    sheet = create :document_sheet

    reference = ""
    sheet.checks.each { |c| reference << c.to_s }
    sheet.reviews.each { |r| reference << r.to_s }
    sheet.themes.each do |t|
      t.options.each { |o| reference << o.to_s }
    end
    assert !reference.blank?

    result = ""
    sheet.each_line { |l| result << l.to_s }

    assert_equal reference, result
  end

  test "assign_author! assigns an author to all new documents, links and checks" do
    sheet = build :document_sheet

    assert_nil sheet.author
    sheet.each_line { |l| assert_nil l.author }

    user1 = create :user
    sheet.assign_author! user1

    assert_equal user1, sheet.author
    sheet.each_line { |l| assert_equal user1, sheet.author }

    # Saving, creating new lines and assigning them a new author
    sheet.save!
    sheet.checks            << build(:check,  document: sheet)
    sheet.reviews           << build(:review, document: sheet)
    sheet.themes[0].options << build(:option, theme: sheet.themes[0])
    new_lines_count = 3

    user2 = create :user
    sheet.assign_author! user2

    assert_equal user1, sheet.author, "The sheet keeps its original author"
    sheet.each_line do |l|
      if user2 == l.author
        new_lines_count -= 1
      else
        assert_equal user1, l.author, "All old lines keep their original author"
      end
    end
    assert_equal 0, new_lines_count,  "All new lines have the new author"
  end

end
