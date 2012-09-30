$LOAD_PATH << '../'
require 'test_helper'

class LinkCategoryTest < ActiveSupport::TestCase
  test "Name is mandatory" do
    theme = link_categories(:systeme)

    assert_required theme, :name

    assert theme.valid?
  end

  test "Name has to be short" do
    theme = link_categories(:systeme)

    assert_max_length theme, name: 32
  end
end
