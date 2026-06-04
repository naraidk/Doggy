class WoufsController < ApplicationController
  before_action :authenticate_user!
  def create
    @post = Post.find(params[:post_id])
    @wouf = @post.woufs.new(dog: current_dog)

    @wouf.save
    redirect_to posts_path
  end

  def destroy
    @post = Post.find(params[:post_id])
    @wouf = @post.woufs.find_by(dog: current_dog)

    @wouf.destroy if @wouf
    redirect_to posts_path
  end
end
