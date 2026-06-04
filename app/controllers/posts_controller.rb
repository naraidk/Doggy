class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.includes(:dog, image_attachment: :blob).order(created_at: :desc)
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.dog = current_user.dogs.find(post_params[:dog_id])

    if @post.save
      redirect_to posts_path, notice: "Post publié !"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_path, notice: "Post supprimé"
  end

  private

  def post_params
    params.require(:post).permit(:content, :image, :dog_id)
  end
end
