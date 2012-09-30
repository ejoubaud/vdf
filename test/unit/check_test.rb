# encoding: utf-8

$LOAD_PATH << '../'
require 'test_helper'

class CheckTest < ActiveSupport::TestCase

  test "Claim, stamp, and remark are mandatory" do
    check = checks(:horus)

    assert_required check, :claim, :remark

    assert check.valid?
  end

  test "Claim and remark have to be short" do
    check = checks(:horus).dup

    assert_max_length check, claim: 140
    assert_max_length check, remark: 140
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
