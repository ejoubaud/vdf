require 'test_helper'

class DocumentTest < ActiveSupport::TestCase
  test "Name, title and description are mandatory on create" do
    Document.create(name: "Nom", title: "Titre", subtitle: "Sous-titre")
  end
end
