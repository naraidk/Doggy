class Event < ApplicationRecord
  belongs_to :dog

  has_many :event_participants, dependent: :destroy
  has_many :dogs, through: :event_participants

  validates :title, :description, :city, :date, presence: true
end
