class WoufsController < ApplicationController
  before_action :authenticate_user!
  def create
    dog = current_user.dogs.find(params[:dog_id] || session[:current_dog_id])

    @wouf = Wouf.new(post_id: params[:post_id], dog: dog)

    if @wouf.save
      redirect_back fallback_location: posts_path
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @wouf = @post.woufs.find_by(dog: current_dog)

    @wouf.destroy if @wouf
    redirect_to posts_path
  end
end
