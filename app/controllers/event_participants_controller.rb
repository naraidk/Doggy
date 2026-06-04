class EventParticipantsController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    @participant = EventParticipant.new
    @participant.event = @event
    @participant.dog = current_user.dogs.first

    if @participant.save
      redirect_to event_path(@event), notice: "Ton chien est inscrit à l'événement."
    else
      redirect_to event_path(@event), alert: "Ton chien est déjà inscrit."
    end
  end
end
