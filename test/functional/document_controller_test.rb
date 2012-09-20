$LOAD_PATH << '../'
require 'test_helper'

class DocumentControllerTest < ActionController::TestCase
  include ActionView::Helpers::JavaScriptHelper
  include ActionView::Helpers::SanitizeHelper

  test "Document request by name returns a document" do
    assert_routing('/documentaire/zeitgeist', :controller => "document", :action => "show", :name => "zeitgeist")
    get :show, { name: 'zeitgeist' }
    assert_response :success

    doc = documents(:zeitgeist)
    do_test_id_card(doc)
    do_test_checklist(doc.checks)
  end

  def do_test_id_card(doc)
    assert_select '#id-card' do
      assert_select('.docu-title', doc.title)
      assert_select('.docu-subtitle', doc.subtitle)
      assert_select('.impact', doc.impact)
      assert_select('.summary', :html => doc.description)
    end
  end

  def do_test_checklist(checklist)
    checks = checklist.dup
    assert_select '#checklist .check' do |elements|
      elements.each do |li|
        check = checks.shift
        assert_select(li, '.claim>p', ERB::Util.html_escape(check.claim))
        escaped = Regexp.escape(ERB::Util.html_escape(check.remark))
        remarkCheck = Regexp.new(%(#{escaped}.*))
        assert_select(li, '.remark>p', remarkCheck)
        assert_select(li, %(img[data-longdesc="#{ check.stamp.description }"]), 1)
        assert_select(li, %(img[alt="#{ check.stamp.title }"]), 1)
      end
    end
    checks.inspect
    assert checks.empty?
  end
end
