class Stamp < ActiveRecord::Base
  attr_accessible :name, :title, :description

  validates :name, :presence => true, length: { maximum: 15 }
  validates :title, :presence => true, length: { maximum: 32 }
end
