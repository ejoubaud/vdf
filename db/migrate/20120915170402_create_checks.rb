class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.string :claim, :limit => 140, :null => false
      t.string :stamp, :limit => 32, :null => false
      t.string :remark, :limit => 140, :null => false
      t.string :ref_url

      t.timestamps
    end
  end
end
