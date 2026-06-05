class CommentsController < ApplicationController
  before_action :authenticate_user!
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.includes(:dog)
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params.merge(dog: current_dog))

    if @comment.save
      @comments = @post.comments.includes(:dog)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to post_comments_path(@post) }
    end
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy

    @comments = @post.comments.includes(:dog)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to post_comments_path(@post) }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
