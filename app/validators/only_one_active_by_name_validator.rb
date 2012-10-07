# encoding: utf-8

class OnlyOneActiveByNameValidator < ActiveModel::Validator

  # Validates that you are not bringing a new active record
  # when there already is another with the same name
  #
  # record - ActiveRecord::Base record with id, active and name fields
  def validate(record)
    if record.active
      activeRecords = record.class.where(name: record.name, active: true)
      # if one exists, but is not the same => error
      if !activeRecords.empty? && !activeRecords.include?(record)
        record.errors[:base] << "Un seul exemplaire d'un nom donné peut être actif à la fois."
      end
    end
  end

end
