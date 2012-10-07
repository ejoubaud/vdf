$LOAD_PATH << '../'
require 'test_helper'

class StampTest < ActiveSupport::TestCase
  test "Name and title are mandatory" do
    stamp = build :stamp

    assert_required stamp, :name, :title

    assert stamp.valid?
  end

  test "Name and title have to be short" do
    stamp = build :stamp

    assert_max_length stamp, name: 15, title: 32
  end
end
