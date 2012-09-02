class Document < ActiveRecord::Base
  attr_accessible :description, :image, :impact, :name, :subtitle, :title

  validates :name, presence: true, length: { maximum: test }
  validates :title, presence: true
  validates :description, presence: true
end
