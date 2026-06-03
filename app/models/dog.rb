class Dog < ApplicationRecord
  belongs_to :user
  has_many :ai_chats, dependent: :destroy  # ← ajouter cette ligne
  # ... reste de tes associations existantes
end
