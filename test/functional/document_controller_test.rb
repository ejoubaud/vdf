$LOAD_PATH << '../'
require 'test_helper'

class DocumentControllerTest < ActionController::TestCase
  test "Document search by name returns a document" do
    assert_routing("/documentaire/zeitgeist", :controller => "document", :action => "show", :name => "zeitgeist")
    get :show, { name: 'zeitgeist' }
    assert_response :success
  end
end
