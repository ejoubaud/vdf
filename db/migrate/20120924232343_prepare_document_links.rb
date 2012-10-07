class PrepareDocumentLinks < ActiveRecord::Migration
  def change
    change_table :links do |t|
      t.change :document_id, :integer, :null => true
    end
  end
end
