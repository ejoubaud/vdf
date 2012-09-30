# encoding: utf-8

class Document < ActiveRecord::Base
  attr_accessible :name, :title, :subtitle, :creator, :creator_url, :description, :impact, :checks_attributes, :reviews_attributes, :themes_attributes

  has_many :checks, dependent: :destroy
  has_many :reviews, class_name: "DocumentLink", dependent: :destroy
  has_many :themes, class_name: "LinkCategory", :include => :links, dependent: :destroy

  accepts_nested_attributes_for :checks, allow_destroy: true, reject_if: proc { |a| [ :claim, :remark ].any? { |att| a[att].blank? } }
  accepts_nested_attributes_for :reviews, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :themes, allow_destroy: true, reject_if: proc { |a| a[:links_attributes].all? { |_, l| l.all? { |k, v| k == '_destroy' || v.blank? } } }

  validates_presence_of :name, :title, :description
  validates :name, length: { maximum: 15 }
  validates :active, inclusion: { :in => [true, false] }
  validates :creator_url, format: { :with => URI::regexp(%w(http https)), :unless => lambda { |d| d.creator_url.blank? } }

  # No URL without name
  validates :creator, presence: { :unless => lambda { |d| d.creator_url.blank? }, :message => "Une URL de créateur doit toujours être accompagnée d'un libellé." }

  # Several inactive drafts may share the same name, but only one version can be active
  validates_with OnlyOneActiveByNameValidator

  def self.sheet_associations() 
    [ :checks,
      :reviews,
      { :themes => :links } ]
  end
  def self.sheet(id_or_name)
    col = id_or_name.is_a?(Integer) ? :id : :name
    where(:active => true, col => id_or_name).includes(sheet_associations).first
  end

  def to_s
    name
  end


#  def reviews_attributes= *arg
#    debugger
#    super *arg
#  end
#
#  def themes_attributes= *arg
#    super *arg
#  end

end
