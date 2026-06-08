class DogsController < ApplicationController
  before_action :set_dog, only: %i[show edit update destroy]

  def index
    @dogs = current_user.dogs
  end

  def show
    @dog = Dog.find(params[:id])
    @photos = @dog.posts.with_attached_image
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
    @dog = current_user.dogs.find(params[:id])
  end

  def edit_avatar
    @dog = current_user.dogs.find(params[:id])
  end

  def update
    @dog = current_user.dogs.find(params[:id])

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
    redirect_to dog_path(@dog), alert: "Impossible de supprimer
        + ce chien."
  end

  def select
    session[:current_dog_id] = params[:dog_id]
    redirect_back fallback_location: posts_path
  end

  private

  def set_dog
    @dog = current_user.dogs.find(params[:id])
  end

  def dog_params
    params.require(:dog).permit(:name, :breed, :age, :gender, :description, :avatar)
  end
end
