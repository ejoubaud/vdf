class AddRoles < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.column :role, :string
    end
  end
end
