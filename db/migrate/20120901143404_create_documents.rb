class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name, :limit => 15, :null => false
      t.string :title, :null => false
      t.string :subtitle
      t.text :description, :null => false
      t.string :impact
      t.string :image
      t.boolean :active, :null => false, :default => false

      t.timestamps
    end
  end
end
