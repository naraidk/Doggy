class Dog < ApplicationRecord
  belongs_to :user

  has_many :conversations_as_one, class_name: "Conversation", foreign_key: "dog_one_id", dependent: :destroy
  has_many :conversations_as_two, class_name: "Conversation", foreign_key: "dog_two_id", dependent: :destroy
end
