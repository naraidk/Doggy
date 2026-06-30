class DogsController < ApplicationController
  before_action :set_dog, only: %i[show matches]
  before_action :set_own_dog, only: %i[edit update destroy]

  def index
    @dogs = current_user.dogs
  end

  def show
    @photos = @dog.posts.with_attached_image
  end

  def matches
    candidates = Dog.where.not(user: current_user)
                    .where.not(id: @dog.id)

    @matches = candidates
               .map { |candidate| [candidate, @dog.compatibility_with(candidate)] }
               .sort_by { |_candidate, score| -score }
               .first(10)
  end

  def new
    @dog = Dog.new
  end

  def create
    @dog = Dog.new(dog_params)
    @dog.user = current_user
    if @dog.save
      redirect_to dog_path(@dog), notice: "Profil du chien créé avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def edit_avatar
    @dog = current_user.dogs.find(params[:id])
  end

  def update
    if @dog.update(dog_params)
      redirect_to dog_path(@dog), notice: "Profil du chien mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @dog.destroy

    redirect_to dogs_path, notice: "Profil du chien supprimé."
  rescue ActiveRecord::InvalidForeignKey
    redirect_to dog_path(@dog), alert: "Impossible de supprimer ce chien."
  end

  def select
    session[:current_dog_id] = params[:dog_id]
    redirect_back fallback_location: posts_path
  end

  private

  def set_dog
    @dog = Dog.find(params[:id])
  end

  def set_own_dog
    @dog = current_user.dogs.find(params[:id])
  end

  def dog_params
    params.require(:dog).permit(
      :name,
      :breed,
      :age,
      :gender,
      :description,
      :avatar,
      :size,
      :energy_level,
      :canine_sociability,
      :human_sociability,
      :temperament,
      :favorite_activity
    )
  end
end
