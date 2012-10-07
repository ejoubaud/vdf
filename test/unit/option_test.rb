$LOAD_PATH << '../'
require 'test_helper'

class OptionTest < ActiveSupport::TestCase

  test "An Option is Link bound to a Theme" do
    link = create :option

    found = Link.find link.id

    assert found.is_a? Option
    assert found.is_a? Link
    assert !found.is_a?(Review)
    assert_equal found.class, Option
  end

end
