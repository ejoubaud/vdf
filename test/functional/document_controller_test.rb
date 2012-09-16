$LOAD_PATH << '../'
require 'test_helper'

class DocumentControllerTest < ActionController::TestCase
  test "Document request by name returns a document" do
    assert_routing('/documentaire/zeitgeist', :controller => "document", :action => "show", :name => "zeitgeist")
    get :show, { name: 'zeitgeist' }
    assert_response :success

    doc = documents(:zeitgeist)
    assert_id_card(doc)
  end

  def assert_id_card(doc)
    assert_select '#id-card' do
      assert_select('.docu-title', doc.title)
      assert_select('.docu-subtitle', doc.subtitle)
      assert_select('.impact', doc.impact)
    end
  end
end
