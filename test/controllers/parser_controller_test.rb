require 'test_helper'

class ParserControllerTest < ActionDispatch::IntegrationTest
  test "should get nokogiri" do
    get parser_nokogiri_url
    assert_response :success
  end

end
