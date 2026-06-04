class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    @conversation = Conversation.find(params[:conversation_id])

    @message = Message.new(message_params)
    @message.conversation = @conversation
    @message.dog = current_user.dogs.find(params[:message][:dog_id])

    if @message.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to conversation_path(@conversation) }
      end
    else
      render "conversations/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
