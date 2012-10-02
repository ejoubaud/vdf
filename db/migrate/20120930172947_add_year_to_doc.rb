class AddYearToDoc < ActiveRecord::Migration
  def change
    change_table :documents do |t|
      t.column :year, :integer, :null => true
    end
  end
end
