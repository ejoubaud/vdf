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

  test "Show body navbar only displays unempty sections" do
    doc = create :document, name: 'sections_test', active: true
    get :show, name: 'sections_test'
    assert_select '.body-nav .nav li', 1

    create :check, document: doc
    get :show, name: 'sections_test'
    assert_select '.body-nav .nav li', 2

    create :review, document: doc
    get :show, name: 'sections_test'
    assert_select '.body-nav .nav li', 3

    create :options_theme, document: doc
    get :show, name: 'sections_test'
    assert_select '.body-nav .nav li', 4
  end


  # ===== NEW Action =====

  test "new request returns new document form" do
    assert_routing '/new', :controller => "document", :action => "new"
  end

  test "new is for signed_in users only" do
    get :new
    assert_response :redirect
    assert_redirected_to controller: 'devise/sessions', action: 'new'
  end

  test "New document form has nested forms for checklist, reviews and themes" do
    sign_in_new_user

    get :new
    assert_response :success

    assert_select '.short-name input', 1
    %w(docu-title docu-subtitle impact).each do |class_name|
      assert_select "#id-card .#{class_name} input", 1
    end
    assert_select '#id-card .director input', 2
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


  # ===== CREATE Action =====

  test "create request routes to the create action" do
    assert_routing '/create', :controller => "document", :action => "create"
  end

  test "create is for signed_in users only" do
    post :create
    assert_response :redirect
    assert_redirected_to controller: 'devise/sessions', action: 'new'
  end

  test "create assigns logged_in user as author to the new document and its lines" do
    doc = attributes_for(:document).except(:name)
    user = sign_in_new_user

    post :create, doc: doc, name: 'created_doc'
    created = Document.sheet 'created_doc'
    assert_equal user, created.author
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

  test "edit is for signed_in users only" do
    doc = create :document, name: 'controller_doc', active: true

    post :edit, name: 'controller_doc'
    assert_response :redirect
    assert_redirected_to controller: 'devise/sessions', action: 'new'
  end

  # TODO - Tester la suppression et le remplacement d'image (doc[remove_poster])


  # ===== UPDATE Action =====

  test "update request routes to the update action" do
    assert_routing '/update/1', :controller => "document", :action => "update", id: "1"
  end

  test "update is for signed_in users only" do
    doc = create :document

    post :update, id: doc.id
    assert_response :redirect
    assert_redirected_to controller: 'devise/sessions', action: 'new'
  end

  test "update assigns logged_in user as author to the document's new lines" do
    doc = create :document, name: 'to_update', active: true
    user1 = create :user
    doc.assign_author! user1
    doc.save!

    stamp = create :stamp
    user2 = sign_in_new_user
    doc_attr = attributes_for(:document, name: 'to_update').except(:name)
    check_attr = attributes_for(:check).merge(stamp_id: stamp.id)

    post :update, id: doc.id, doc: doc_attr.merge(checks_attributes: { "new_1111" => check_attr })
    updated = Document.sheet 'to_update'
    assert_equal user1, updated.author
    assert_equal user2, updated.checks.first.author
  end


# ===== *** HELPERS *** =====

private

  # ===== GENERAL HELPERS =====
  def sign_in_new_user
    user = create :user
    sign_in user
    user
  end

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
