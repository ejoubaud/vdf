class CreateLinks < ActiveRecord::Migration
  def change
    create_table :links do |t|
      t.string :title, :limit => 32, :null => false
      t.string :url, :null => false
      t.string :description, :limit => 255, :null => false
      t.references :document, :null => false

      t.string :category, :limit => 32
      t.string :type

      t.timestamps
    end
  end
end
