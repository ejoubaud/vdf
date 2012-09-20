# encoding: utf-8

$LOAD_PATH << '../'
require 'test_helper'

class CheckTest < ActiveSupport::TestCase

  test "Claim, stamp, and remark are mandatory" do
    base_check = checks(:horus)

    [ :claim=, :remark= ].each do |setter| 
      check = base_check.dup
      check.send(setter, nil)
      assert check.invalid?
    end

    assert base_check.valid?
  end

  test "Claim and remark have to be short" do
    base_check = checks(:horus).dup

    over140 = "This string is a little bit longer than the 140 characters we impose on both our claims and remarks, remorselessly copying the Twitter shortness policy."
    equals140 = "This string has an exact length of 140 characters, which is the maximum we impose on both our claims and remarks so that users can read fast"

    { :claim= => over140, :remark= => over140 }.each do |setter, value| 
      check = base_check.dup
      check.send(setter, value)
      assert check.invalid?
    end

    { :claim= => equals140, :remark= => equals140 }.each do |setter, value| 
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

  test "Check can access its eagerly loaded stamps" do
    check = checks(:horus)
    assert check.association(:stamp).loaded?
    assert check.stamp.is_a? Stamp
    assert_equal check.stamp.name, 'false'
  end

  test "to_s" do
    check = checks(:horus)
    assert_equal "#{check}", "zeitgeist: false, Le personnage de Jésus est déj..."
  end

end
