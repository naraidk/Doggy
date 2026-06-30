require "test_helper"

class ConversationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user         = users(:alice)
    @conversation = conversations(:rex_buddy_chat)
  end

  test "unauthenticated access redirects to sign_in" do
    get conversations_path
    assert_redirected_to new_user_session_path
  end

  test "should get index" do
    sign_in @user
    get conversations_path
    assert_response :success
  end

  test "should get show" do
    sign_in @user
    get conversation_path(@conversation)
    assert_response :success
  end

  test "should create or find conversation" do
    sign_in @user
    post conversations_path, params: {
      dog_one_id: dogs(:rex).id,
      dog_two_id: dogs(:buddy).id
    }
    assert_redirected_to conversation_path(@conversation)
  end
end
