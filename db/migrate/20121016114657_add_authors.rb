class AddAuthors < ActiveRecord::Migration
  def change
    change_table :links do |t|
      t.column :author_id, :integer
    end
    change_table :checks do |t|
      t.column :author_id, :integer
    end
    change_table :documents do |t|
      t.column :author_id, :integer
    end
  end
end
