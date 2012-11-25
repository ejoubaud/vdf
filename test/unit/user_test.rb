require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Login and email are mandatory" do
    user = build :user

    assert_required user, :login, :email

    assert_nothing_raised { user.save! }
  end

  test "to_s returns login" do
    user = build :user
    assert_equal user.login, "#{user}"
  end

  test "user's default role is :user" do
    user = create :user
    assert_equal :user, user.role

    admin = create :user, role: :admin
    assert_equal :admin, admin.role

    editor = create :user, role: :editor
    assert_equal :editor, editor.role
  end
end
