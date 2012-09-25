class CategoryLink < Link
  belongs_to :category, class_name: "LinkCategory", foreign_key: :link_category_id

  validates :category, presence: true

  def to_s
    cat = category.nil? ? "" : category.name
    "#{cat} > #{title}"
  end
end
