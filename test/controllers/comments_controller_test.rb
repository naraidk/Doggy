require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user    = users(:alice)
    @post    = posts(:rex_post)
    @comment = comments(:rex_comment)
  end

  test "unauthenticated access redirects to sign_in" do
    get post_comments_path(@post)
    assert_redirected_to new_user_session_path
  end

  test "should get comments index" do
    sign_in @user
    get post_comments_path(@post)
    assert_response :success
  end

  test "should create comment" do
    sign_in @user
    assert_difference("Comment.count") do
      post post_comments_path(@post), params: { comment: { content: "Quel beau chien !" } }
    end
    assert_response :redirect
  end

  test "should destroy comment" do
    sign_in @user
    assert_difference("Comment.count", -1) do
      delete post_comment_path(@post, @comment)
    end
    assert_response :redirect
  end
end
