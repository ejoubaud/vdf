# encoding: utf-8

class Document < ActiveRecord::Base
  attr_accessible :description, :image, :active, :impact, :name, :subtitle, :title, :active, :creator, :creator_url

  validates :name, presence: true, length: { maximum: 15 }
  validates :title, presence: true
  validates :description, presence: true
  validates :active, inclusion: { :in => [true, false] }
  validates :creator_url, format: { :with => URI::regexp(%w(http https)), :unless => lambda { |d| d.creator_url.blank? } }
  
  # No URL without name
  validates :creator, presence: { :unless => lambda { |d| d.creator_url.blank? }, :message => "Une URL de créateur doit toujours être accompagnée d'un libellé." }

  # Several inactive drafts may share the same name, but only one version can be active
  validates_with OnlyOneActiveByNameValidator
end
