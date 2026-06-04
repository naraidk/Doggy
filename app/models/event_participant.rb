class EventParticipant < ApplicationRecord
  belongs_to :event
  belongs_to :dog

  validates :dog_id, uniqueness: { scope: :event_id }
end
