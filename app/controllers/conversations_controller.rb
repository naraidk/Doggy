class ConversationsController < ApplicationController
  before_action :authenticate_user!

  def index
    my_dogs = current_user.dogs

    @conversations = Conversation
                     .where(dog_one: my_dogs)
                     .or(Conversation.where(dog_two: my_dogs))
                     .order(updated_at: :desc)

    @dog = current_dog
    @ai_chats = @dog ? @dog.ai_chats.order(created_at: :desc) : []
  end

  def show
    @conversation = Conversation.find(params[:id])
    @message = Message.new
  end

  

  def create
    dog_one = current_user.dogs.find(params[:dog_one_id])
    dog_two = Dog.find(params[:dog_two_id])

    @conversation = Conversation.find_by(dog_one: dog_one, dog_two: dog_two) ||
                    Conversation.find_by(dog_one: dog_two, dog_two: dog_one) ||
                    Conversation.create!(dog_one: dog_one, dog_two: dog_two)

    redirect_to conversation_path(@conversation)
  end
end
