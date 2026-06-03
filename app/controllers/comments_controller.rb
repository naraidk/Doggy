class CommentsController < ApplicationController
  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.includes(:dog)
  end

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.new(comment_params.merge(dog: current_dog))

    @comment.save
    redirect_to post_comments_path(@post)
  end

  def destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
