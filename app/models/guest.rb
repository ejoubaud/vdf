class Guest
  extend  ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  def initialize
    # basic config of guest user!
  end

  def create options = {}
    # new instance and set valid attributes?
  end

  def email
    'guest@versionsdesfaits.com'
  end

  def has_role? role
    role.to_sym == :guest
  end

  def persisted?
    false
  end
end 