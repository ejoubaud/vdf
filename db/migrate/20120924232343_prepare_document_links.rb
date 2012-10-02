class PrepareDocumentLinks < ActiveRecord::Migration
  def change
    change_table :links do |t|
      t.change :document_id, :integer
    end
  end
end
