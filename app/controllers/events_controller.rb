class EventsController < ApplicationController
  before_action :authenticate_user!
  def index
    @events = Event.order(date: :asc)
  end

  def show
    @event = Event.find(params[:id])
    @participant = EventParticipant.new
    @existing_participant = @event.event_participants.find_by(dog: current_user.dogs)
  end

  def new
    @event = Event.new
  end

  def edit
    @event = current_user.dogs.flat_map(&:events).find { |e| e.id == params[:id].to_i }
    redirect_to events_path unless @event
  end

  def update
    @event = current_user.dogs.flat_map(&:events).find { |e| e.id == params[:id].to_i }
    redirect_to events_path and return unless @event

    if @event.update(event_params)
      redirect_to event_path(@event)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, notice: "Événement supprimé."
  end

  def create
    @event = Event.new(event_params)
    @event.dog ||= current_dog

    if @event.save
      redirect_to event_path(@event)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :city, :date, :dog_id)
  end
end
