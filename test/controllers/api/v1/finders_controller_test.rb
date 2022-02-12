require "test_helper"

class Api::V1::FindersControllerTest < ActionDispatch::IntegrationTest
  test "should get finder" do
    get api_v1_finders_finder_url
    assert_response :success
  end
end
