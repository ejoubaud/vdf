class DocumentLink < Link
  belongs_to :document

  validates :document, presence: true
end
