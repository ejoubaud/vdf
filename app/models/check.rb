class Check < ActiveRecord::Base
  attr_accessible :claim, :remark, :ref_url, :stamp_id

  belongs_to :document
  belongs_to :stamp

  # Always load stamp
  default_scope includes(:stamp)

  validates_presence_of :claim, :remark, :stamp
  validates :claim, length: { maximum: 140 }
  validates :remark, length: { maximum: 140 }
  validates :ref_url, format: { :with => URI::regexp(%w(http https)), :unless => lambda { |d| d.ref_url.blank? } }

  def to_s
    s_doc = document.nil? ? "<document_less>" : document.name
    s_stamp = stamp.nil? ? "<stamp_less>" : stamp.name
    s_claim = claim.to_s[0, 30]
    "#{s_doc}: #{s_stamp}, #{s_claim}..."
  end
end
