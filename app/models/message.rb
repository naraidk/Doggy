class Message < ApplicationRecord
  belongs_to :conversation
  belongs_to :dog

 after_create_commit :broadcast_message, unless: -> { Rails.env.production? && ENV["SEEDING"] == "true" }

  private

  def broadcast_message
    broadcast_append_to(
      "conversation_#{conversation.id}_messages",
      target: "messages",
      partial: "messages/message",
      locals: {
        message: self
      }
    )
  end
end
