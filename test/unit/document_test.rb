$LOAD_PATH << '../'
require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  test "Name, title, descrpiption and active are mandatory" do
    doc = documents(:zeitgeist)

    assert_required doc, :name, :title, :description, :active, :year

    assert_nothing_raised { doc.save! }
  end

  test "Name has to be short (<=15 chars)" do
    doc = documents(:zeitgeist)
    
    assert_max_length doc, name: 15
  end

  test "Year is between 1900 and 2025" do
    doc = documents(:zeitgeist)
    
    doc.year = 1899
    assert doc.invalid?
    doc.year = 2026
    assert doc.invalid?
    doc.year = 1900
    assert doc.valid?
    doc.year = 2025
    assert doc.valid?
  end

  # Instantiates only the mandatory attributes
  def new_with_same_name(doc)
    new_doc = Document.new
    new_doc.attributes = { name: doc.name, title: doc.title+'-diff', description: doc.description+'-diff', year: doc.year }
    new_doc
  end

  test "Only one can be active for each name" do
    doc = documents(:zeitgeist)

    assert_nothing_raised do
      doc.active = true
      doc.save!
    end

    # Create mode
    same_name_doc = new_with_same_name(doc)

    assert_raise(ActiveRecord::RecordInvalid) do
      same_name_doc.active = true
      same_name_doc.save!
    end

    assert_nothing_raised do
      same_name_doc.active = false
      same_name_doc.save!
    end

    # Update mode
    assert_raise(ActiveRecord::RecordInvalid) do
      same_name_doc.active = true
      same_name_doc.save!
    end
  end

  test "Many inactive drafts for each name is fine" do
    doc = documents(:zdraft)

    assert_nothing_raised do
      doc.dup.save!
    end
  end

  test "Director URL needs to be a URL" do
    doc = documents(:zdraft).dup

    doc.director_url = ""
    assert doc.valid?
    doc.director_url = "http://www.google.com/"
    assert doc.valid?

    doc.director_url = "htp://www.google.com/"
    assert doc.invalid?
  end

  test "Director URL needs a director" do
    doc = documents(:zdraft).dup
    doc.director_url = "http://www.facebook.com"
    
    doc.director = nil
    assert doc.invalid?
    doc.director = "Mark Zuckerberg"
    assert doc.valid?

  end

  test "Checklist has accessible elements" do
    doc = documents(:zeitgeist)

    assert doc.checks.size > 1
    assert doc.checks[0].is_a? Check
  end

  test "sheet method eagerly loads all you need to display on a doc sheet" do
    doc = Document.where(name: 'zeitgeist').first
    assert !doc.association(:checks).loaded?, "Basic requests don't fetch the checklist."
    assert !doc.association(:reviews).loaded?, "Basic requests don't fetch the reviews."
    assert !doc.association(:themes).loaded?, "Basic requests don't fetch the themes."
    doc = documents(:zeitgeist)
    assert !doc.association(:checks).loaded?, "Fixtures requests don't fetch the checklist."
    assert !doc.association(:reviews).loaded?, "Fixtures requests don't fetch the reviews."
    assert !doc.association(:themes).loaded?, "Fixtures requests don't fetch the themes."

    sheet = Document.sheet('zeitgeist')
    assert sheet.association(:checks).loaded?, "Sheet eagerly fetches checklist for given name."
    assert sheet.association(:reviews).loaded?, "Sheet eagerly fetches reviews for given name."
    assert sheet.association(:themes).loaded?, "Sheet eagerly fetches themes for given name."

    id = ActiveRecord::Fixtures.identify(:zeitgeist)
    sheet = Document.sheet(id)
    assert sheet.association(:checks).loaded?, "Sheet does the job with id too (checklist)."
    assert sheet.association(:reviews).loaded?, "Sheet does the job with id too (reviews)."
    assert sheet.association(:themes).loaded?, "Sheet does the job with id too (themes)."

    assert_nothing_raised do
      assert Document.sheet('wontwork').nil?, "sheet returns nil when no ID/name matches"
    end
  end

  test "to_s" do
    doc = documents(:zeitgeist)
    assert_equal "#{doc}", doc.name
  end

end
