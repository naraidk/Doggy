class Swipe < ApplicationRecord
  belongs_to :dog
  belongs_to :target_dog, class_name: "Dog"

  validates :target_dog_id, uniqueness: { scope: :dog_id }
end
