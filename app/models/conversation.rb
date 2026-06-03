class Conversation < ApplicationRecord
  belongs_to :dog_one, class_name: "Dog"
  belongs_to :dog_two, class_name: "Dog"
  has_many :messages, dependent: :destroy
end
