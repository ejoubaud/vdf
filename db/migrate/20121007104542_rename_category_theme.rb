class RenameCategoryTheme < ActiveRecord::Migration
  def change
    rename_table :link_categories, :themes
    change_table :links do |t|
      t.rename :link_category_id, :theme_id
    end
  end
end
