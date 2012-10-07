$LOAD_PATH << '../'
require 'test_helper'

class CategoryLinkTest < ActiveSupport::TestCase

  test "A link with category is a category link" do
    link = create :category_link

    found = Link.find link.id

    assert found.is_a? CategoryLink
    assert found.is_a? Link
    assert !found.is_a?(DocumentLink)
    assert_equal found.class, CategoryLink
  end

end
