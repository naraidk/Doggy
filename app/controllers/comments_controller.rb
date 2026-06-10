class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.find(params[:post_id])
    @comments = @post.comments.includes(:dog)
  end

  def create
    @post = Post.find(params[:post_id])
    dog = current_user.dogs.find_by(id: params[:dog_id]) || current_dog

    @comment = Comment.new(comment_params)
    @comment.post = @post
    @comment.dog = dog

    if @comment.save
      @comments = @post.comments.includes(:dog)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to post_comments_path(@post) }
      end
    else
      render turbo_stream: turbo_stream.replace("comment_form", partial: "comments/form", locals: { post: @post, comment: @comment })
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
