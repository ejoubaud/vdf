$LOAD_PATH << '../'
require 'test_helper'

class StampTest < ActiveSupport::TestCase
    test "Name and title are mandatory" do
    base_stamp = stamps(:falsestamp)

    [:name=, :title=].each do |setter| 
      stamp = base_stamp.dup
      stamp.send(setter, '')
      assert stamp.invalid?
    end

    assert base_stamp.valid?
  end

  test "Name and title have to be short" do
    base_stamp = stamps(:falsestamp).dup

    over32 = "aMoreThanThirtyTwoCharactersStamp"
    equals32 = "aThirtyTwoCharactersStampExactly"
    over15 = "Exceeds 15 chars"
    equals15 = "Equals 15 chars"

    { :name= => over15, :title= => over32 }.each do |setter, value| 
      stamp = base_stamp.dup
      stamp.send(setter, value)
      assert stamp.invalid?
    end

    { :name= => equals15, :title= => equals32 }.each do |setter, value| 
      stamp = base_stamp.dup
      stamp.send(setter, value)
      assert stamp.valid?
    end
  end
end
