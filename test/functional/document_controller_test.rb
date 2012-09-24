$LOAD_PATH << '../'
require 'test_helper'

class DocumentControllerTest < ActionController::TestCase
  include ERB::Util

  test "Document request by name returns a document" do
    assert_routing('/documentaire/zeitgeist', :controller => "document", :action => "show", :name => "zeitgeist")
    get :show, { name: 'zeitgeist' }
    assert_response :success

    doc = documents(:zeitgeist)
    do_test_id_card(doc)
    do_test_checklist(doc.checks)
    do_test_reviews(doc.reviews)
    do_test_alternatives(doc.links_by_category)
  end

  def do_test_id_card(doc)
    assert_select '#id-card' do
      assert_select('.docu-title', doc.title)
      assert_select('.docu-subtitle', doc.subtitle)
      assert_select('.impact', doc.impact)
      assert_select('.summary', :html => doc.description)
      assert_select('.editor', doc.creator) unless doc.creator.blank?
      assert_select('.editor[href=?]', doc.creator_url) unless doc.creator_url.blank?
    end
  end

  def do_test_checklist(checklist)
    checks = checklist.dup

    assert_select '#checklist .check' do |elements|
      elements.each do |li|
        check = checks.shift

        assert_select(li, '.claim>p', h(check.claim))

        escaped = Regexp.escape(h(check.remark))
        remarkCheck = Regexp.new(%(#{escaped}.*))
        assert_select(li, '.remark>p', remarkCheck)

        assert_select(li, %(img[data-longdesc="#{ check.stamp.description }"]), 1)
        assert_select(li, %(img[alt="#{ check.stamp.title }"]), 1)
      end
    end
    assert checks.empty?, "Bad number of checks"
  end

  def do_test_reviews(reviews_list)
      assert_select '#reviews' do |elements|
        do_test_link_list elements[0], reviews_list
      end
    end
  end

  def do_test_alternatives(links_by_category)
    links_by_cat = links_by_category.dup

    assert_select '#options>ul>li' do |elements|
      elements.each do |li|
        category, links = *links_by_cat.shift

        assert_select li, 'h3', h(category)

        do_test_link_list li, links
      end
    end
    assert links_by_cat.empty?, "Bad number of categories"
  end

  def do_test_link_list(parent, link_list)
    links = link_list.dup
    assert_select(parent, '.link-list li') do |elements|
      elements.each do |li|
        link = links.shift

        assert_select li, '.text-unit>p', h(link.description)

        assert_select(li, 'h4') do
          assert_select 'a', h(link.title)
          assert_select 'a[href=?]', link.url
        end
      end
    end
    links.inspect
    assert links.empty?, "Bad number of links"
  end