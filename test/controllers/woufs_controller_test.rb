require "test_helper"

class WoufsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
  end

  test "unauthenticated create redirects to sign_in" do
    post post_woufs_path(posts(:rex_post))
    assert_redirected_to new_user_session_path
  end

  test "should create wouf" do
    sign_in @user
    assert_difference("Wouf.count") do
      post post_woufs_path(posts(:rex_post))
    end
    assert_response :redirect
  end

  test "should destroy wouf" do
    sign_in @user
    assert_difference("Wouf.count", -1) do
      delete post_wouf_path(posts(:buddy_post), woufs(:rex_wouf))
    end
    assert_response :redirect
  end
end
