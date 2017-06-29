require 'minitest/autorun'
require './main'

class Test < Minitest::Test

  def test_compare_jsons
    json_output = File.read('output.json').strip()
    json_my_output = File.read('my_output.json').strip()

    assert_equal json_output, json_my_output
  end
end
