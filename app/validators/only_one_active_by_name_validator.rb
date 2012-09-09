# Validates that you are not bringing a new active record when there already is another with the same name
#
# * *Args*    :
#   - +record+ -> Record with id, active and name fields
#
class OnlyOneActiveByNameValidator < ActiveModel::Validator
  def validate(record)
    if record.active && !record.id.nil?
      activeRecords = record.class.find(active: true)
      if !activeRecords.map( |r| r.id ).include? record.id
        record.errors[:base] << "Un seul exemplaire d'un nom donné peut être actif à la fois."
      end
    end
  end
end
