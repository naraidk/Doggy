class Dog < ApplicationRecord
  belongs_to :user

  validates :name, presence: true, length: { minimum: 2, maximum: 30 }

  validates :breed, presence: true

  validates :description, presence: true, length: { minimum: 12, maximum: 300 }

  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than: 30 }

  validates :user, presence: true
end
