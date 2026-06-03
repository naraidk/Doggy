class AiMessage < ApplicationRecord
  belongs_to :ai_chat
  validates :content, presence: true          # ← ajouter
  validates :role, inclusion: { in: %w[user assistant] }  # ← ajouter
end
