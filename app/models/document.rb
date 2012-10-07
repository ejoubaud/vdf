# encoding: utf-8
#require 'file_size_validator' 

class Document < ActiveRecord::Base
  attr_accessible :name, :title, :subtitle, :director, :director_url, :description, :impact, :poster, :year, :checks_attributes, :reviews_attributes, :themes_attributes

  has_many :checks, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :themes, :include => :options, dependent: :destroy

  mount_uploader :poster, PosterUploader

  accepts_nested_attributes_for :checks, reject_if: proc { |a| a[:claim].blank? || a[:remark].blank? }
  accepts_nested_attributes_for :reviews, reject_if: :all_blank
  accepts_nested_attributes_for :themes,
                                   #Reject linkless themes
                                   reject_if: proc { |a|
                                       a[:options_attributes].all? do |_, link|
                                         link.all? do |key, val|
                                           key == '_destroy' || val.blank?
                                         end
                                       end
                                     }

  validates_presence_of :name, :title, :description, :year
  validates :name, length: { maximum: 15 }
  validates :active, inclusion: { :in => [true, false] }
  validates :year, inclusion: { :in => 1900..2025 }
  validates :director_url, format: { :with => URI::regexp(%w(http https)), :unless => lambda { |d| d.director_url.blank? } }
  validates :poster, :file_size => { :maximum => 0.5.megabytes.to_i }

  # No URL without name
  validates :director, presence: { :unless => lambda { |d| d.director_url.blank? }, :message => "Une URL de réalisateur doit toujours être accompagnée d'un libellé." }

  # Several inactive drafts may share the same name, but only one version can be active
  validates_with OnlyOneActiveByNameValidator

  # List of association eagerly fetched by self.sheet
  def self.sheet_associations() 
    [ :checks,
      :reviews,
      :themes ]
  end

  # Eagerly loads the checklist, reviews and themes with the document
  # (cf. self.sheet_associations)
  #
  # id_or_name - Either Integer id or String name
  # active     - Boolean can be given false to fetch the draft version (default: true)
  def self.sheet(id_or_name, active = true)
    col = id_or_name.is_a?(Integer) ? :id : :name

    where(col => id_or_name, :active => active).includes(sheet_associations).first
  end

  def to_s
    name
  end

end
