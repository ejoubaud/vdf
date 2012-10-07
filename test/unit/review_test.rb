$LOAD_PATH << '../'
require 'test_helper'

class ReviewTest < ActiveSupport::TestCase

  test "A Review is Link bound to a Document" do
    link = create :review

    found = Link.find link.id
    assert found.is_a? Review
    assert found.is_a? Link
    assert !found.is_a?(Option)
    assert_equal found.class, Review
  end

end