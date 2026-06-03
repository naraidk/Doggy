# app/controllers/conversations_controller.rb

class ConversationsController < ApplicationController
  before_action :authenticate_user!

  #def index
  #  my_dogs = current_user.dogs

   # @conversations = Conversation
   #                  .where(dog_one: my_dogs)
    #                 .or(Conversation.where(dog_two: my_dogs))
  #end

  def show
    @conversation = Conversation.find(params[:id])
    @message = Message.new
  end

  #def new
  #  @dog = Dog.find(params[:dog_id])
  #end

  def create
    dog_one = current_user.dogs.first
    dog_two = Dog.find(params[:dog_two_id])

    @conversation = Conversation.find_or_create_by(
      dog_one: dog_one,
      dog_two: dog_two
    )

    redirect_to conversation_path(@conversation)
  end
end
