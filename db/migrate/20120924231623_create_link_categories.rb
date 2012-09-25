class CreateLinkCategories < ActiveRecord::Migration
  def change
    create_table :link_categories do |t|
      t.string :name, :limit => 32, :null => false
      t.references :document

      t.timestamps
    end

    change_table :links do |t|
      t.remove :category
      t.references :link_category
    end
  end
end
