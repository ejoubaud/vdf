class AddDocumentCreator < ActiveRecord::Migration
  change_table :documents do |t|
    t.index :name
    t.rename :image, :poster
    t.column :creator, :string, :limit => 32
    t.column :creator_url, :string
  end
end
