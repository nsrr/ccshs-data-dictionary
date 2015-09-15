require 'test_helper'

class DictionaryTest < Minitest::Test
  # This line includes all default Spout Dictionary tests
  include Spout::Tests

  # This line provides access to @variables, @forms, and @domains
  # iterators that can be used to write custom tests
  include Spout::Helpers::Iterators

 # Example 1: Create custom tests to show that `integer` and `numeric` variables have a valid unit type
  VALID_UNITS = ["", "beats per minute", "centimeters", "nights", "minutes per week", "grams per day", "kilocalories per day",
    "days", "drinks", "hours", "kilograms per square centimeter",
    "kilograms", "kilograms per square meter", "millimeters of mercury", "minutes",
    "percent", "years", "snacks", "meals", "arousals per hour"]

  @variables.select{|v| ['numeric','integer'].include?(v.type)}.each do |variable|
    define_method("test_units: "+variable.path) do
      message = "\"#{variable.units}\"".colorize( :red ) + " invalid units.\n" +
                "             Valid types: " +
                VALID_UNITS.sort.collect{|u| u.inspect.colorize( :white )}.join(', ')
      assert VALID_UNITS.include?(variable.units), message
    end
  end

  USED_UNITS = @variables.collect{|v| v.units}.uniq.compact

  def test_no_unused_units
    assert_equal [], VALID_UNITS - USED_UNITS
  end

end
