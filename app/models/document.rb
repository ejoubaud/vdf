class Document < ActiveRecord::Base
  attr_accessible :description, :image, :active, :impact, :name, :subtitle, :title, :active

  validates :name, presence: true, length: { maximum: 15 }
  validates :title, presence: true
  validates :description, presence: true
  validates :active, inclusion: { :in => [true, false] }
  validates_with OnlyOneActiveByNameValidator
end
