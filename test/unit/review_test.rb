$LOAD_PATH << '../'
require 'test_helper'

class ReviewTest < ActiveSupport::TestCase

  test "A Review is Link bound to a Document" do
    link = create :review

    found = Link.find link.id
    assert found.is_a? Review
    assert found.is_a? Link
    assert !found.is_a?(Option)
    assert_equal found.class, Review
  end

  test "Review can have an author" do
    author  = build :user, login: 'author'
    link    = build :review, author: author

    assert_equal User, link.author.class
    assert_equal 'author', link.author.login
    assert link.is_a? Authored
  end

end