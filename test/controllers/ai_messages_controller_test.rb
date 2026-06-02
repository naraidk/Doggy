require "test_helper"

class AiMessagesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get ai_messages_create_url
    assert_response :success
  end
end
