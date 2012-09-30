class LinkCategory < ActiveRecord::Base
  attr_accessible :name, :links_attributes

  belongs_to :document
  has_many :links, dependent: :destroy, class_name: "CategoryLink"

  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank

  #validates_presence_of :document
  validates_presence_of :name
  validates :name, length: { maximum: 32 }
end
