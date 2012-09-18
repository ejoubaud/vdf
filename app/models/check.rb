class Check < ActiveRecord::Base
  attr_accessible :claim, :remark, :ref_url

  belongs_to :stamp
  belongs_to :document

  # Always load stamp
  default_scope includes(:stamp)

  validates :claim, presence: true, length: { maximum: 140 }
  validates :stamp, presence: true
  validates :remark, presence: true, length: { maximum: 140 }
  validates :ref_url, format: { :with => URI::regexp(%w(http https)), :unless => lambda { |d| d.ref_url.blank? } }
end
