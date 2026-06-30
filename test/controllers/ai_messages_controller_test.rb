require "test_helper"

class AiMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user    = users(:alice)
    @dog     = dogs(:rex)
    @ai_chat = ai_chats(:rex_chat)
  end

  test "unauthenticated access redirects to sign_in" do
    post dog_ai_chat_ai_messages_path(@dog, @ai_chat),
         params: { ai_message: { content: "Mon chien tousse." } }
    assert_redirected_to new_user_session_path
  end

  test "should create ai_message" do
    sign_in @user

    fake_response = Struct.new(:content).new("Voici mes conseils vétérinaires.")
    fake_chat = Object.new
    fake_chat.define_singleton_method(:with_instructions) { |_| fake_chat }
    fake_chat.define_singleton_method(:add_message) { |**_| nil }
    fake_chat.define_singleton_method(:ask) { |_| fake_response }

    original_chat = RubyLLM.method(:chat)
    RubyLLM.define_singleton_method(:chat) { fake_chat }

    begin
      assert_difference("AiMessage.count", 2) do
        post dog_ai_chat_ai_messages_path(@dog, @ai_chat),
             params: { ai_message: { content: "Mon chien tousse souvent." } }
      end
      assert_response :redirect
    ensure
      RubyLLM.define_singleton_method(:chat, original_chat)
    end
  end
end
