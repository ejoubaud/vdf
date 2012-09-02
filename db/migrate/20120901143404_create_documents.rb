class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name, :limit => 14
      t.string :title
      t.string :subtitle
      t.text :description
      t.string :impact
      t.string :image

      t.timestamps
    end
  end
end
