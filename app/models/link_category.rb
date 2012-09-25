class LinkCategory < ActiveRecord::Base
  attr_accessible :name

  belongs_to :document
  has_many :links, class_name: "CategoryLink"

  validates_presence_of :document, :name
  validates :name, length: { maximum: 32 }
end
