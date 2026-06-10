class WoufsController < ApplicationController
  before_action :authenticate_user!
  def create
    @post = Post.find(params[:post_id])
    dog = current_user.dogs.find_by(id: params[:dog_id]) || current_dog

    @wouf = Wouf.new(post: @post, dog: dog)

    if @wouf.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_back fallback_location: posts_path }
      end
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @wouf = @post.woufs.find_by(dog: current_dog)

    @wouf.destroy if @wouf

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to posts_path }
    end
  end
end
