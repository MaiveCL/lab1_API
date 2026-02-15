require "test_helper"

class ApiTestControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_test_index_url
    assert_response :success
  end
end
