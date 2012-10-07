ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Turns String or Symbol AR attribute name into its setter's symbol :attribute=
  def to_setter(field)
    field.to_s.concat("=").to_sym
  end

  # Public: Tests max_length strings let base_object valid
  # and max_length+1 strings make it invalid through AR validation
  #
  # base_object - The object to be tested.
  # length_by_setter_sym - Hash of integer values by symbol keys :
  #                        { :field => max_length }
  #                        fields must have setters in base_object
  #
  # Examples
  #
  #   assert_max_length(last_post, :twit= => 140, :name= => 32 )
  #   # => true
  #
  # Returns nothing.
  # Raises ActiveRecord::RecordInvalid if base_object field unvalidates with
  #                                    lower or validates with higher length.
  def assert_max_length(base_object, length_by_field)
    length_by_field.each do |field, max_length| 
      obj = base_object.dup
      setter = to_setter(field)

      obj.send(setter, "a" * max_length)
      assert obj.valid?, "The actual max length for #{setter} is lower than #{max_length}."

      obj.send(setter, "a" * (max_length + 1))
      assert obj.invalid?, "The actual max length for #{setter} is higher than #{max_length}."
    end
  end

  # Public: Tests that the fields are required through AR validation
  #
  # base_object - The object to be tested.
  # *fields - Array of fields with setters in base_object
  #
  # Examples
  #
  #   assert_required(document, :name, :email)
  #   # => true
  #
  # Returns nothing.
  # Raises ActiveRecord::RecordInvalid if base_object validates with nil or
  #                                    empty in given fields.
  def assert_required(base_object, *fields)
    fields.each do |field|
      obj = base_object.dup
      setter = to_setter(field)

      obj.send(setter, nil)
      assert obj.invalid?, "Validation allows nil value for #{field}."

      if obj.column_for_attribute(field) == :string
        obj.send(setter, "")
        assert obj.invalid?, "Validation allows empty value for #{field}."
      end
    end
  end
end
