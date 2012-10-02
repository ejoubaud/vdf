# encoding: utf-8
#require 'file_size_validator' 

class Document < ActiveRecord::Base
  attr_accessible :name, :title, :subtitle, :creator, :creator_url, :description, :impact, :poster, :year, :checks_attributes, :reviews_attributes, :themes_attributes

  has_many :checks, dependent: :destroy
  has_many :reviews, class_name: "DocumentLink", dependent: :destroy
  has_many :themes, class_name: "LinkCategory", :include => :links, dependent: :destroy

  mount_uploader :poster, PosterUploader

  accepts_nested_attributes_for :checks, allow_destroy: true, reject_if: proc { |a| a[:claim].blank? || a[:remark].blank? }
  accepts_nested_attributes_for :reviews, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :themes, allow_destroy: true,
                                         #Reject linkless themes
                                         reject_if: proc { |a|
                                             a[:links_attributes].all? do |_, link|
                                               link.all? do |key, val|
                                                 key == '_destroy' || val.blank?
                                               end
                                             end
                                           }

  validates_presence_of :name, :title, :description, :year
  validates :name, length: { maximum: 15 }
  validates :active, inclusion: { :in => [true, false] }
  validates :year, inclusion: { :in => 1900..2025 }
  validates :creator_url, format: { :with => URI::regexp(%w(http https)), :unless => lambda { |d| d.creator_url.blank? } }
  validates :poster, :file_size => { :maximum => 0.5.megabytes.to_i }

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

  def reject_linkless_themes
  end

  def to_s
    name
  end

end
