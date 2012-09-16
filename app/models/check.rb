class Check < ActiveRecord::Base
  attr_accessible :claim, :stamp, :remark, :ref_url

  belongs_to :document

  validates :claim, presence: true, length: { maximum: 140 }
  validates :stamp, presence: true, length: { maximum: 32 }
  validates :remark, presence: true, length: { maximum: 140 }
  validates :ref_url, format: { :with => URI::regexp(%w(http https)), :unless => lambda { |d| d.ref_url.blank? } }
end
