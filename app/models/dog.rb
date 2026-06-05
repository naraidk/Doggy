class Dog < ApplicationRecord
  belongs_to :user
  has_many :ai_chats, dependent: :destroy # ← ajouter cette ligne
  # ... reste de tes associations existantes
  has_one_attached :avatar

  validates :name, presence: true, length: { minimum: 2, maximum: 30 }

  validates :breed, presence: true

  validates :description, presence: true, length: { minimum: 12, maximum: 300 }

  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 30 }

  validates :user, presence: true

  has_many :conversations_as_one, class_name: "Conversation", foreign_key: "dog_one_id", dependent: :destroy
  has_many :conversations_as_two, class_name: "Conversation", foreign_key: "dog_two_id", dependent: :destroy
end
