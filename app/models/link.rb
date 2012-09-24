class Link < ActiveRecord::Base
  attr_accessible :title, :url, :description

  belongs_to :document

  validates_presence_of :url, :title, :description, :document
  validates :title, length: { maximum: 32 }
  validates :description, length: { maximum: 255 }

  def to_s
    "#{title}"
  end
end
