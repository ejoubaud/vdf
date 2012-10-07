# encoding: utf-8

$LOAD_PATH << '../'
require 'test_helper'

class CheckTest < ActiveSupport::TestCase

  test "Claim, stamp, and remark are mandatory" do
    check = build :check

    assert_required check, :claim, :remark

    assert check.valid?
  end

  test "Claim and remark have to be short" do
    check = build :check

    assert_max_length check, claim: 140
    assert_max_length check, remark: 140
  end

  test "ref_url needs to be a URL" do
    check = build :check

    check.ref_url = ""
    assert check.valid?
    check.ref_url = "http://www.google.com/"
    assert check.valid?

    check.ref_url = "htp://www.google.com/"
    assert check.invalid?
  end

  test "Check can access its document" do
    check = build :check

    assert check.document.is_a? Document
  end

  test "Check can access its eagerly loaded stamps" do
    stamp = build :stamp, name: 'our_stamp'
    check = create :check, stamp: stamp

    found = Check.find check.id
    assert found.association(:stamp).loaded?
    assert found.stamp.is_a? Stamp
    assert_equal 'our_stamp', check.stamp.name
  end

  test "to_s returns '<doc.name>: <stamp.name>, <claim's first 30 chars>...'" do
    document = build :document, name: 'check_doc'
    stamp = build :stamp, name: 'stamp_name'
    check = build :check, document: document, stamp: stamp, claim: "a"*31
    assert_equal "#{check}", "check_doc: stamp_name, aaaaaaaaaaaaaaaaaaaaaaaaaaa..."

    check.claim = "a"*30
    assert_equal "#{check}", "check_doc: stamp_name, aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"

    check.claim = nil
    assert_equal "#{check}", "check_doc: stamp_name, "

    check.document = nil
    assert_equal "#{check}", "<no_doc>: stamp_name, "

    check.stamp = nil
    assert_equal "#{check}", "<no_doc>: <no_stamp>, "
  end

end
