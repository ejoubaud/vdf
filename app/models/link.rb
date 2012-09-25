class Link < ActiveRecord::Base
  attr_accessible :title, :url, :description

  validates_presence_of :url, :title, :description
  validates :title, length: { maximum: 32 }
  validates :description, length: { maximum: 255 }

  def to_s
    "#{title}"
  end
end
