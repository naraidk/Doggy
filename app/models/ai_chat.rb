class AiChat < ApplicationRecord
  belongs_to :dog
  has_many :ai_messages, dependent: :destroy  # ← ajouter

  def generate_title_from_first_message  # ← ajouter
    first_msg = ai_messages.where(role: "user").first
    update(title: first_msg&.content&.truncate(50) || "Nouvelle conversation")
  end
end

