class LinkChecks < ActiveRecord::Migration
  def change

    create_table :stamps do |t|
      t.string :name, :limit => 15, :unique => true, :null => false
      t.string :title, :limit => 32, :null => false
      t.string :description
      t.references :document
    end

    change_table :checks do |t|
      t.remove :stamp
      t.references :stamp
      t.references :document
    end

  end
end
