class DogsController < ApplicationController
  def index
    @dogs = current_user.dogs
  end

  def show
    @dog = Dog.find(params[:id])
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

  def update
    @dog = current_user.dogs.find(params[:id])

    if @dog.update(dog_params)
      redirect_to dog_path(@dog), notice: "Profil du chien mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @dog = Dog.find(params[:id])
    @dog.destroy
    redirect_to dogs_path, notice: "Profil du chien supprimé."
  end

  private

  def dog_params
    dog_params = params.require(:dog).permit(:name, :breed, :age, :description)
  end
end
