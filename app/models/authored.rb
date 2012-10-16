module Authored
  extend ActiveSupport::Concern

  included do
    attr_accessible :author

    belongs_to :author, foreign_key: :author_id, class_name: "User"
  end
end
