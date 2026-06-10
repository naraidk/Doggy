class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    posts  = Post.includes(:dog, image_attachment: :blob).all
    events = Event.includes(dog: { avatar_attachment: :blob }).all
    @feed  = (posts + events).sort_by(&:created_at).reverse
  end

  def new
    @post = Post.new
  end

  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end


  def post_panel
    @post = Post.find(params[:id])
    render partial: "posts/panel", locals: { post: @post }
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
