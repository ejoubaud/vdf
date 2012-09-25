$LOAD_PATH << '../'
require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  
  test "Title, URL, description and document are mandatory" do
    link = links(:skeptic)

    assert_required link, :title, :description, :url, :document

    assert link.valid?
  end

  test "Name and title have to be short" do
    link = links(:skeptic)

    assert_max_length link, description: 255, title: 32
  end

  test "A link without category is a link" do
    link = links(:skeptic)

    assert link.is_a? DocumentLink
    assert link.is_a? Link
    assert !link.is_a?(CategoryLink)
    assert_equal link.class, DocumentLink
  end

end
