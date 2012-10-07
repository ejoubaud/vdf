$LOAD_PATH << '../'
require 'test_helper'

class LinkTest < ActiveSupport::TestCase

  test "A link without category is a document link" do
    link = create :document_link

    found = Link.find link.id
    assert found.is_a? DocumentLink
    assert found.is_a? Link
    assert !found.is_a?(CategoryLink)
    assert_equal found.class, DocumentLink
  end

end