require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about_us" do
    get static_pages_about_us_url
    assert_response :success
  end

end
