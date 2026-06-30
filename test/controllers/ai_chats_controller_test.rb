require "test_helper"

class AiChatsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user    = users(:alice)
    @dog     = dogs(:rex)
    @ai_chat = ai_chats(:rex_chat)
  end

  test "unauthenticated access redirects to sign_in" do
    get dog_ai_chats_path(@dog)
    assert_redirected_to new_user_session_path
  end

  test "should get index" do
    sign_in @user
    get dog_ai_chats_path(@dog)
    assert_response :success
  end

  test "should get show" do
    sign_in @user
    get dog_ai_chat_path(@dog, @ai_chat)
    assert_response :success
  end

  test "should create ai_chat" do
    sign_in @user
    assert_difference("AiChat.count") do
      post dog_ai_chats_path(@dog)
    end
    assert_response :redirect
  end
end
