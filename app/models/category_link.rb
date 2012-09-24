class CategoryLink < Link
  attr_accessible :category

  validates :category, presence: true, length: { maximum: 32 }

  def to_s
    "#{category} > #{title}"
  end
end
