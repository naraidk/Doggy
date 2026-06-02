require "test_helper"

class WoufsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get woufs_create_url
    assert_response :success
  end

  test "should get destroy" do
    get woufs_destroy_url
    assert_response :success
  end
end
