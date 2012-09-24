$LOAD_PATH << '../'
require 'test_helper'

class CategoryLinkTest < ActiveSupport::TestCase

  test "Category, title, URL, description and document are mandatory" do
    link = links(:monnaie)

    assert_required link, :category

    assert link.valid?
  end

  test "Category has to be short" do
    link = links(:monnaie)

    assert_max_length(link, :category => 32)
  end


  test "A link with category is a category link" do
    link = links(:monnaie)

    assert link.is_a? CategoryLink
    assert link.is_a? Link
    assert_equal link.class, CategoryLink
  end

end
