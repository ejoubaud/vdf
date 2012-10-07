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
    create :document, name: 'doc', active: true

    assos = [ :checks, :reviews, :themes ]

    doc = Document.where(name: 'doc').first
    assos.each { |a| assert !doc.association(a).loaded?, "Basic requests don't fetch the #{a}." }

    sheet = Document.sheet('doc')
    assos.each { |a| assert sheet.association(a).loaded?,  "sheet eagerly fetches #{a} for given name." }

    id = sheet.id
    id_sheet = Document.sheet(id)
    assos.each { |a| assert id_sheet.association(a).loaded?,  "sheet does the job with id too (#{a})." }

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

end
