$LOAD_PATH << '../'
require 'test_helper'

class LinkCategoryTest < ActiveSupport::TestCase
  test "Name is mandatory" do
    theme = build :link_category

    assert_required theme, :name

    assert theme.valid?
  end

  test "Name has to be short" do
    theme = build :link_category

    assert_max_length theme, name: 32
  end
end
