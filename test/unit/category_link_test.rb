$LOAD_PATH << '../'
require 'test_helper'

class CategoryLinkTest < ActiveSupport::TestCase

  test "A link with category is a category link" do
    link = links(:monnaie)

    assert link.is_a? CategoryLink
    assert link.is_a? Link
    assert !link.is_a?(DocumentLink)
    assert_equal link.class, CategoryLink
  end

end
