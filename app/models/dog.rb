class Dog < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  has_many :ai_chats, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :event_participants, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :woufs, dependent: :destroy
  has_many :conversations_as_one, class_name: "Conversation", foreign_key: "dog_one_id", dependent: :destroy
  has_many :conversations_as_two, class_name: "Conversation", foreign_key: "dog_two_id", dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :breed, presence: true
  validates :description, presence: true, length: { minimum: 12, maximum: 300 }
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 30 }
  validates :user, presence: true
end
