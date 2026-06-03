class Post < ApplicationRecord
  belongs_to :dog
  has_many :comments, dependent: :destroy
  has_many :woufs, dependent: :destroy
  has_one_attached :image
end
