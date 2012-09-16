$LOAD_PATH << '../'
require 'test_helper'

class DocumentTest < ActiveSupport::TestCase

  test "Name, title, descrpiption and active are mandatory" do
    base_doc = documents(:zeitgeist)

    [:name=, :title=, :description=, :active=].each do |setter| 
      assert_raise(ActiveRecord::RecordInvalid) do
        doc = base_doc.dup
        doc.send(setter, '')
        doc.save!
      end
    end

    assert_nothing_raised { base_doc.save! }
  end

  test "Name has to be short (<=15 chars)" do
    doc = documents(:zeitgeist).dup
    assert_nothing_raised do
      doc.name = "Equals 15 chars"
      doc.save!
    end
    assert_raise(ActiveRecord::RecordInvalid) do
      doc.name = "Exceeds 15 chars"
      doc.save!
    end
  end

  # Instantiates only the mandatory attributes
  def new_with_same_name(doc)
    new_doc = Document.new
    new_doc.attributes = { name: doc.name, title: doc.title+'-diff', description: doc.description+'-diff' }
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

  test "Creator URL needs to be a URL" do
    doc = documents(:zdraft).dup

    assert_nothing_raised do
      doc.creator_url = ""
      doc.save!
      doc.creator_url = "http://www.google.com/"
      doc.save!
    end

    assert_raise(ActiveRecord::RecordInvalid) do
      doc.creator_url = "htp://www.google.com/"
      doc.save!
    end
  end

  test "Creator URL needs a creator" do
    doc = documents(:zdraft).dup
    doc.creator_url = "http://www.facebook.com"
    assert_raise(ActiveRecord::RecordInvalid) do
      doc.creator = nil
      doc.save!
    end
    assert_nothing_raised do
      doc.creator = "Mark Zuckerberg"
      doc.save!
    end
  end

  test "Checklist has accessible elements" do
    doc = documents(:zeitgeist)
    assert doc.checks.size > 1
    assert doc.checks[0].is_a? Check
  end

end
