class EventParticipantsController < ApplicationController
  before_action :authenticate_user!
  def create
    @event = Event.find(params[:event_id])
    @participant = EventParticipant.new
    @participant.event = @event
    @participant.dog = current_user.dogs.first

    if @participant.save
      redirect_back fallback_location: events_path, notice: "Ton chien est inscrit à l'événement."
    else
      redirect_back fallback_location: events_path, alert: "Ton chien est déjà inscrit."
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    @participant = @event.event_participants.find_by(dog_id: current_user.dogs.ids)

    if @participant
      @participant.destroy
      redirect_back fallback_location: events_path, status: :see_other, notice: "Désinscription prise en compte."
    else
      redirect_back fallback_location: events_path, status: :see_other,
                    alert: "Impossible de trouver votre inscription."
    end
  end
end
