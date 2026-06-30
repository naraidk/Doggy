require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @post = posts(:rex_post)
    @dog  = dogs(:rex)
  end

  test "unauthenticated access redirects to sign_in" do
    get posts_path
    assert_redirected_to new_user_session_path
  end

  test "should get index" do
    sign_in @user
    get posts_path
    assert_response :success
  end

  test "should get new" do
    sign_in @user
    get new_post_path
    assert_response :success
  end

  test "should get show" do
    sign_in @user
    get post_path(@post)
    assert_response :success
  end

  test "should create post" do
    sign_in @user
    assert_difference("Post.count") do
      post posts_path, params: { post: { content: "Nouveau post de test !", dog_id: @dog.id } }
    end
    assert_redirected_to posts_path
  end

  test "should destroy post" do
    sign_in @user
    assert_difference("Post.count", -1) do
      delete post_path(@post)
    end
    assert_redirected_to posts_path
  end
end
