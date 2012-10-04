$LOAD_PATH << '../'
require 'test_helper'

class VdfControllerTest < ActionController::TestCase
  # ===== INDEX Action =====

  test "Index is the root of the site" do
    assert_redirected_to('/', :controller => "vdf", :action => "index")
    get :index
    assert_response :success
  end
end
