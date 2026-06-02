class EventParticipant < ApplicationRecord
  belongs_to :event
  belongs_to :dog
end
