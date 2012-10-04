class RenameDocCreatorToDirector < ActiveRecord::Migration
  def change
    change_table :documents do |t|
      t.rename :creator, :director
      t.rename :creator_url, :director_url
    end
  end
end
