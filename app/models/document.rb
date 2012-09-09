class Document < ActiveRecord::Base
  attr_accessible :description, :image, :impact, :name, :subtitle, :title
  attr_reader

  validates :name, presence: true, length: { maximum: 15 }
  validates :title, presence: true
  validates :description, presence: true
  validates_with OnlyOneActiveByNameValidator
end
