# encoding: utf-8

# Validates that you are not bringing a new active record when there already is another with the same name
#
# * *Args*    :
#   - +record+ -> Record with id, active and name fields
#
class OnlyOneActiveByNameValidator < ActiveModel::Validator
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
