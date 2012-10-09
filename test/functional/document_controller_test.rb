$LOAD_PATH << '../'
require 'test_helper'

class DocumentControllerTest < ActionController::TestCase
  include ERB::Util
  include Devise::TestHelpers

  # ===== SHOW Action =====

  test "Document request by name returns a document" do
    doc = create :document, name: 'controller_doc', active: true

    assert_routing '/controller_doc', controller: 'document', action: 'show', name: 'controller_doc'
  end

  test "Showing a document displays its fields" do
    doc = create :document_sheet, name: 'controller_doc', active: true

    get :show, name: 'controller_doc'
    assert_response :success

    do_test_id_card doc
    do_test_checklist doc.checks
    do_test_reviews doc.reviews
    do_test_alternatives doc.themes
  end


  # ===== NEW Action =====

  test "new request returns new document form" do
    assert_routing '/new', :controller => "document", :action => "new"
  end

  test "New document form has nested forms for checklist, reviews and themes" do
    get :new
    assert_response :success

    assert_select '.short-name input', 1
    %w(docu-title docu-subtitle impact).each do |class_name|
      assert_select "#id-card .#{class_name} input", 1
    end
    assert_select '#id-card .editor input', 2
    assert_select '#id-card .summary textarea', 1

    nb_links = 2
    assert_select '#reviews .link-list .link', nb_links do
      assert_select 'input', 3*nb_links
      assert_select 'textarea', nb_links
    end

    nb_links = 4
    assert_select '#options .link-list .link', nb_links do
      assert_select 'input', 3*nb_links
      assert_select 'textarea', nb_links
    end
  end


  # ===== LIST Action =====

  test "list request returns the documents list page" do
    assert_routing '/list', :controller => 'document', :action => 'list'
  end

  test "List request returns a list of all active documents" do
    get :list
    assert_response :success

    nb_docs = Document.where(active: true).count
    assert_select '.body section li', nb_docs
  end


  # ===== EDIT Action =====

  test "edit returns the edit form for a document identified by its name" do
    doc = create :document, name: 'controller_doc', active: true

    assert_routing '/edit/controller_doc', controller: 'document', action: 'edit', name: 'controller_doc'
  end




# ===== *** HELPERS *** =====

private

  # ===== SHOW HELPERS =====

  def do_test_id_card(doc)
    assert_select '#id-card' do
      assert_select '.docu-title', doc.title
      assert_select '.docu-subtitle', doc.subtitle
      assert_select '.impact', doc.impact unless doc.impact.blank?
      assert_select '.summary', :html => doc.description.strip
      assert_select('.editor a', doc.director) unless doc.director.blank?
      assert_select('.editor a[href=?]', doc.director_url) unless doc.director_url.blank?
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
        assert_select li, '.remark>p', remarkCheck 

        longdesc_count = check.stamp.description.blank? ? 0 : 1
        assert_select li, %(img[data-longdesc="#{ check.stamp.description }"]), longdesc_count
        assert_select li, %(img[alt="#{ check.stamp.title }"]), 1
      end
    end
    assert checks.empty?, "Bad number of checks"
  end

  def do_test_reviews(reviews_list)
      assert_select '#reviews' do |elements|
        do_test_link_list elements[0], reviews_list
      end
  end

  def do_test_alternatives themes_list
    themes = themes_list.dup

    assert_select '#options>ul>li' do |elements|
      elements.each do |li|
        cat = themes.shift

        assert_select li, 'h3', h(cat.name)

        do_test_link_list li, cat.options
      end
    end
    assert themes.empty?, "Bad number of themes"
  end

  def do_test_link_list parent, link_list
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
    assert links.empty?, "Bad number of options"
  end

end
