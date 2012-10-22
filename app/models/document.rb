# encoding: utf-8

class Document < ActiveRecord::Base
  include Authored

  attr_accessible :title, :subtitle, :director, :director_url, :description, :impact, :poster, :year, :checks_attributes, :reviews_attributes, :themes_attributes, :remove_poster

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

  # Eagerly loads the checklist, reviews and themes with the document
  # (cf. self.sheet_associations)
  #
  # id_or_name - Either Integer id or String name
  # active     - Boolean can be given false to fetch the draft version (default: true)
  def self.sheet(id_or_name, active = true)
    col = id_or_name.is_a?(Integer) ? :id : :name

    where(col => id_or_name, :active => active)
      .includes([ :checks, :reviews, :themes ])
      .first
  end

  # Applies a block to each line of the sheet (checks and links)
  def each_line
    checks.each { |c| yield c }
    reviews.each { |r| yield r }
    themes.each do |t|
      t.options.each { |o| yield o }
    end
  end

  # Assigns an author to the doc and to its lines (checks and links) if new
  def assign_author! user
    self.author ||= user
    each_line do |l|
      l.author ||= user
    end
  end

  def to_s
    name
  end

end
