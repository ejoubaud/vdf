$LOAD_PATH << '../'
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Login and email are mandatory" do
    user = build :user

    assert_required user, :login, :email

    assert_nothing_raised { user.save! }
  end
end
