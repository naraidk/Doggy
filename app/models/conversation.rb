class Conversation < ApplicationRecord
  belongs_to :dog_one, class_name: "Dog"
  belongs_to :dog_two, class_name: "Dog"

  has_many :messages, dependent: :destroy

  def other_dog(current_user)
    dog_one.user == current_user ? dog_two : dog_one
  end
end
