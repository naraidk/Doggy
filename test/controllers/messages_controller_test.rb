require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user         = users(:alice)
    @conversation = conversations(:rex_buddy_chat)
    @dog          = dogs(:rex)
  end

  test "unauthenticated access redirects to sign_in" do
    post conversation_messages_path(@conversation),
         params: { message: { content: "Salut !", dog_id: @dog.id } }
    assert_redirected_to new_user_session_path
  end

  test "should create message" do
    sign_in @user
    assert_difference("Message.count") do
      post conversation_messages_path(@conversation),
           params: { message: { content: "Salut Buddy !", dog_id: @dog.id } }
    end
    assert_response :redirect
  end
end
