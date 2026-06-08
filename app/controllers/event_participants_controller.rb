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

  def destroy
    @event = Event.find(params[:event_id])

    # On cherche la participation qui correspond au premier chien de l'utilisateur pour cet événement
    @participant = @event.event_participants.find_by(dog_id: current_user.dogs.ids)

    if @participant
      @participant.destroy
      # Le status: :see_other est obligatoire pour que Turbo (Rails 7) mette à jour la page HTML
      redirect_to event_path(@event), status: :see_other, notice: "Désinscription prise en compte."
    else
      redirect_to event_path(@event), status: :see_other, alert: "Impossible de trouver votre inscription."
    end
  end
end
