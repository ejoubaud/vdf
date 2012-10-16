$LOAD_PATH << '../'
require 'test_helper'

class OptionTest < ActiveSupport::TestCase

  test "An Option is Link bound to a Theme" do
    link = create :option

    found = Link.find link.id

    assert found.is_a? Option
    assert found.is_a? Link
    assert !found.is_a?(Review)
    assert_equal found.class, Option
  end

  test "Option can have an author" do
    author  = build :user, login: 'author'
    link    = build :option, author: author

    assert_equal User, link.author.class
    assert_equal 'author', link.author.login
    assert link.is_a? Authored
  end

end
