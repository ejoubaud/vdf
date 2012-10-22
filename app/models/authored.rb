module Authored
  extend ActiveSupport::Concern

  included do

    belongs_to :author, foreign_key: :author_id, class_name: "User"

  end
end
