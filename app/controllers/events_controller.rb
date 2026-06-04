class EventsController < ApplicationController
  before_action :authenticate_user!

  def index
    @events = Event.order(date: :asc)
  end

  def show
    @event = Event.find(params[:id])
    @participant = EventParticipant.new
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.dog = current_user.dogs.first

    if @event.save
      redirect_to event_path(@event)
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :city, :date)
  end
end
