$LOAD_PATH << '../'
require 'test_helper'

class CheckTest < ActiveSupport::TestCase

  test "Claim, stamp, and remark are mandatory" do
    base_check = checks(:horus)

    [:claim=, :stamp=, :remark=].each do |setter| 
      check = base_check.dup
      check.send(setter, '')
      assert check.invalid?
    end

    assert base_check.valid?
  end

  test "Claim, remark and stamp have to be short" do
    base_check = checks(:horus).dup

    over140 = "This string is a little bit longer than the 140 characters we impose on both our claims and remarks, remorselessly copying the Twitter shortness policy."
    equals140 = "This string has an exact length of 140 characters, which is the maximum we impose on both our claims and remarks so that users can read fast"
    over32 = "aMoreThanThirtyTwoCharactersStamp"
    equals32 = "aThirtyTwoCharactersStampExactly"

    { :claim= => over140, :remark= => over140,  :stamp= => over32 }.each do |setter, value| 
      check = base_check.dup
      check.send(setter, value)
      assert check.invalid?
    end

    { :claim= => equals140, :remark= => equals140,  :stamp= => equals32 }.each do |setter, value| 
      check = base_check.dup
      check.send(setter, value)
      assert check.valid?
    end
  end

  test "ref_url needs to be a URL" do
    check = checks(:horus).dup

    check.ref_url = ""
    assert check.valid?
    check.ref_url = "http://www.google.com/"
    assert check.valid?

    check.ref_url = "htp://www.google.com/"
    assert check.invalid?
  end

  test "Check can access its document" do
    check = checks(:horus)
    assert check.document.is_a? Document
    assert_equal check.document.name, 'zeitgeist'
  end

end
