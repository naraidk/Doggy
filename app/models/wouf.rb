class Wouf < ApplicationRecord
  belongs_to :dog
  belongs_to :post

  validates :dog_id, uniqueness: { scope: :post_id }
end
