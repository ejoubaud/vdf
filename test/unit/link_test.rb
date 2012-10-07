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

end
