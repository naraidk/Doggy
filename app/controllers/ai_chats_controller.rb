class AiChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dog

  def show
    @ai_chat = AiChat.find(params[:id])
    @ai_message = AiMessage.new
  end

  def create
    @ai_chat = @dog.ai_chats.create(title: "Nouvelle conversation")
    redirect_to dog_ai_chat_path(@dog, @ai_chat)
  end

  private

  def set_dog
    @dog = Dog.find(params[:dog_id])
  end
end
