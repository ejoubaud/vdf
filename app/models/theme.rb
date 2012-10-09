class Theme < ActiveRecord::Base
  attr_accessible :name, :options_attributes

  belongs_to :document
  has_many :options, dependent: :destroy

  accepts_nested_attributes_for :options, reject_if: :all_blank

  #validates_presence_of :document
  validates_presence_of :name
  validates :name, length: { maximum: 32 }
end
