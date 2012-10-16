$LOAD_PATH << '../'
require 'test_helper'

class LinkTest < ActiveSupport::TestCase
  
  test "Title, URL and description are mandatory" do
    link = build :link

    assert_required link, :title, :description, :url

    assert link.valid?
  end

  test "Name and title have to be short" do
    link = build :link

    assert_max_length link, description: 255, title: 32
  end

  test "Link can have an author" do
    author = build :user, login: 'author'
    link    = build :link, author: author

    assert_equal User, link.author.class
    assert_equal 'author', link.author.login
    assert link.is_a? Authored
  end

end
