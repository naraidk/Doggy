class SwipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @dog = current_user.dogs.first
    @restart = params[:restart].present?

    swiped_ids = @restart ? [] : Swipe.where(dog: @dog).pluck(:target_dog_id)

    @target_dog = Dog
                  .where.not(user: current_user)
                  .where.not(id: swiped_ids)
                  .max_by { |candidate| @dog.compatibility_with(candidate) }

    @score = @dog.compatibility_with(@target_dog) if @target_dog
  end

  def create
    @dog = current_user.dogs.first
    @target_dog = Dog.find(params[:target_dog_id])

    @swipe = Swipe.find_or_initialize_by(dog: @dog, target_dog: @target_dog)
    @swipe.update!(liked: params[:liked] == "true")

    restart_param = params[:restart].present? ? { restart: true } : {}
    redirect_to swipes_path(restart_param), notice: match_message
  end

  private

  def match_message
    return unless @swipe.liked?

    reciprocal_like = Swipe.exists?(
      dog: @target_dog,
      target_dog: @dog,
      liked: true
    )

    reciprocal_like ? "C'est un match avec #{@target_dog.name} !" : nil
  end
end
