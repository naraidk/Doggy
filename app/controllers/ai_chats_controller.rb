class AiChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_dog

  def index
    @ai_chats = @dog.ai_chats.order(created_at: :desc)
  end

  def create
    @ai_chat = @dog.ai_chats.create!
    redirect_to dog_ai_chat_path(@dog, @ai_chat), notice: "Chat IA créé."
  end

  def show
    @ai_chat = @dog.ai_chats.find(params[:id])
    @ai_message = AiMessage.new
  end

  private

  def set_dog
    @dog = Dog.find(params[:dog_id])
  end
end
