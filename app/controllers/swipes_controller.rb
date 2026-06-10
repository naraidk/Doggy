class SwipesController < ApplicationController
  before_action :authenticate_user!

  def index
    @current_dog = current_user.dogs.find_by(id: params[:dog_id]) || current_user.dogs.first

    @liked_count = Swipe.where(dog: @current_dog, liked: true).count

    if session[:undo_dog_id].present?
      @target_dog = Dog.find_by(id: session.delete(:undo_dog_id))
    else
      swiped_ids = Swipe.where(dog: @current_dog).pluck(:target_dog_id)

      @target_dog = Dog
                    .where.not(user: current_user)
                    .where.not(id: swiped_ids)
                    .max_by { |candidate| @current_dog.compatibility_with(candidate) }
    end

    @score = @current_dog.compatibility_with(@target_dog) if @target_dog
  end

  def create
    @current_dog = current_user.dogs.find(params[:dog_id])
    @target_dog = Dog.find(params[:target_dog_id])

    @swipe = Swipe.create!(
      dog: @current_dog,
      target_dog: @target_dog,
      liked: params[:liked] == "true"
    )

    redirect_to swipes_path(dog_id: @current_dog.id), notice: match_message
  end

  def undo
    @current_dog = current_user.dogs.find(params[:dog_id])

    last_swipe = Swipe.where(dog: @current_dog).order(created_at: :desc).first

    if last_swipe.present?
      session[:undo_dog_id] = last_swipe.target_dog_id
      last_swipe.destroy
    end

    redirect_to swipes_path(dog_id: @current_dog.id)
  end

  def liked
    @current_dog = current_user.dogs.find_by(id: params[:dog_id]) || current_user.dogs.first

    liked_ids = Swipe.where(dog: @current_dog, liked: true).pluck(:target_dog_id)

    @liked_dogs = Dog.where(id: liked_ids)
    @liked_count = @liked_dogs.count
  end

  private

  def match_message
    return unless @swipe.liked?

    reciprocal_like = Swipe.exists?(
      dog: @target_dog,
      target_dog: @current_dog,
      liked: true
    )

    reciprocal_like ? "C'est un match avec #{@target_dog.name} !" : nil
  end
end
