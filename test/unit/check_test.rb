$LOAD_PATH << '../'
require 'test_helper'

class CheckTest < ActiveSupport::TestCase

  test "Claim, stamp, and remark are mandatory" do
    base_doc = checks(:horus)

    [:claim=, :stamp=, :remark=].each do |setter| 
      doc = base_doc.dup
      doc.send(setter, '')
      assert doc.invalid?
    end

    assert base_doc.valid?
  end

  test "Claim, remark and stamp have to be short" do
    base_doc = checks(:horus).dup

    over140 = "This string is a little bit longer than the 140 characters we impose on both our claims and remarks, remorselessly copying the Twitter shortness policy."
    equals140 = "This string has an exact length of 140 characters, which is the maximum we impose on both our claims and remarks so that users can read fast"
    over32 = "aMoreThanThirtyTwoCharactersStamp"
    equals32 = "aThirtyTwoCharactersStampExactly"

    { :claim= => over140, :remark= => over140,  :stamp= => over32 }.each do |setter, value| 
      doc = base_doc.dup
      doc.send(setter, value)
      assert doc.invalid?
    end

    { :claim= => equals140, :remark= => equals140,  :stamp= => equals32 }.each do |setter, value| 
      doc = base_doc.dup
      doc.send(setter, value)
      assert doc.valid?
    end
  end

  test "ref_url needs to be a URL" do
    doc = checks(:horus).dup

    doc.ref_url = ""
    assert doc.valid?
    doc.ref_url = "http://www.google.com/"
    assert doc.valid?

    doc.ref_url = "htp://www.google.com/"
    assert doc.invalid?
  end

end
