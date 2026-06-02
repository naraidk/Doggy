require "test_helper"

class AiChatsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get ai_chats_show_url
    assert_response :success
  end

  test "should get new" do
    get ai_chats_new_url
    assert_response :success
  end

  test "should get create" do
    get ai_chats_create_url
    assert_response :success
  end
end
