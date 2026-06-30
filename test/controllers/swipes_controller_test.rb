require "test_helper"

class SwipesControllerTest < ActionDispatch::IntegrationTest
  test "unauthenticated access redirects to sign_in" do
    get swipes_path
    assert_redirected_to new_user_session_path
  end

  test "should get index" do
    sign_in users(:alice)
    get swipes_path
    assert_response :success
  end

  test "should create swipe" do
    sign_in users(:bob)
    assert_difference("Swipe.count") do
      post swipes_path, params: {
        dog_id: dogs(:buddy).id,
        target_dog_id: dogs(:rex).id,
        liked: "true"
      }
    end
    assert_response :redirect
  end
end
