class MapsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = Event.where.not(latitude: nil, longitude: nil)
    @events_json = @events.map do |event|
      {
        id: event.id,
        title: event.title,
        city: event.city,
        date: event.date.strftime("%d/%m/%Y"),
        latitude: event.latitude,
        longitude: event.longitude,
        url: event_path(event)
      }
    end.to_json
  end
end
