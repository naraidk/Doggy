require "test_helper"

class EventParticipantsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get event_participants_create_url
    assert_response :success
  end

  test "should get destroy" do
    get event_participants_destroy_url
    assert_response :success
  end
end
