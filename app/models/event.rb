class Event < ApplicationRecord
  belongs_to :dog

  has_many :event_participants, dependent: :destroy
  has_many :dogs, through: :event_participants

  validates :title, :description, :city, :date, presence: true

  geocoded_by :city
  after_validation :geocode, if: :will_save_change_to_city?
end
