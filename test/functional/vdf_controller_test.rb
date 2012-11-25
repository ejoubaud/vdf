require 'test_helper'

class VdfControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # ===== INDEX Action =====

  test "Index is the root of the site" do
    assert_routing '/', controller: "vdf", action: "index"
    get :index
    assert_response :success
  end

  test "Index is accessible to anyone" do
    get :index
    assert_response :success, "Guests are allowed"

    sign_in create(:user)
    get :index
    assert_response :success, "Logged-in users are allowed"
  end

  # ===== ABOUT Action =====

  test "vdf/a-propos routes to about section" do
    assert_routing '/vdf/a-propos', controller: "vdf", action: "about"
    get :about
    assert_response :success
  end

  test "About is accessible to anyone" do
    get :about
    assert_response :success, "Guests are allowed"

    sign_in create(:user)
    get :about
    assert_response :success, "Logged-in users are allowed"
  end

end
