$LOAD_PATH << '../'
require 'test_helper'

class LinkTest < ActiveSupport::TestCase

  test "A link without category is a document link" do
    link = links(:skeptic)

    assert link.is_a? DocumentLink
    assert link.is_a? Link
    assert !link.is_a?(CategoryLink)
    assert_equal link.class, DocumentLink
  end

end