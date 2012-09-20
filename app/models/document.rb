# encoding: utf-8

class Document < ActiveRecord::Base
  attr_accessible :description, :image, :active, :impact, :name, :subtitle, :title, :active, :creator, :creator_url

  has_many :checks

  validates_presence_of :name, :title, :description
  validates :name, length: { maximum: 15 }
  validates :active, inclusion: { :in => [true, false] }
  validates :creator_url, format: { :with => URI::regexp(%w(http https)), :unless => lambda { |d| d.creator_url.blank? } }

  # No URL without name
  validates :creator, presence: { :unless => lambda { |d| d.creator_url.blank? }, :message => "Une URL de créateur doit toujours être accompagnée d'un libellé." }

  # Several inactive drafts may share the same name, but only one version can be active
  validates_with OnlyOneActiveByNameValidator

  def self.sheet_associations() [ :checks ]; end
  def self.sheet(id_or_name)
    col = id_or_name.is_a?(Integer) ? :id : :name
    where(:active => true, col => id_or_name).includes(sheet_associations).first
  end

  def to_s
    name
  end
end
