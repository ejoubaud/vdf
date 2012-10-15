$LOAD_PATH << '../../'
require 'test_helper'

class DocumentHelperTest < ActionView::TestCase

  test "nav_list returns all sections under { title => section_id } format" do
    awaited = DocumentHelper::SECTIONS.reduce({}) do |list, section|
      list[section[:title]] = section[:id]
      list
    end
    assert_equal awaited, nav_list
  end

  test "nav_list's :show filters sections empty in a doc'" do
    doc = build :document, reviews: [], checks: [], themes: []
    results = nav_list(:show, doc)
    assert_equal 1, results.count
  end

end
