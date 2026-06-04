class AiMessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_ai_chat

  def create
    @ai_message = @ai_chat.ai_messages.build(ai_message_params.merge(role: "user"))

    if @ai_message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history

      instructions = "Tu es un assistant vétérinaire bienveillant spécialisé dans les chiens."
      response = @ruby_llm_chat.with_instructions(instructions).ask(@ai_message.content)

      @assistant_message = @ai_chat.ai_messages.create(
        role: "assistant",
        content: response.content
      )
      @ai_chat.generate_title_from_first_message

      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to dog_ai_chat_path(@ai_chat.dog, @ai_chat) }
      end
    else
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.update(
            "new_ai_message_container",
            partial: "ai_messages/form",
            locals: { ai_chat: @ai_chat, ai_message: @ai_message }
          )
        }
        format.html { render "ai_chats/show", status: :unprocessable_entity }
      end
    end
  end

  private

  def set_ai_chat
    @ai_chat = AiChat.find(params[:ai_chat_id])
  end

  def ai_message_params
    params.require(:ai_message).permit(:content)
  end

  def build_conversation_history
    @ai_chat.ai_messages.each do |msg|
      @ruby_llm_chat.add_message(msg)
    end
  end
end
