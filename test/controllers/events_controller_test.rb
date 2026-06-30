require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user  = users(:alice)
    @event = events(:dog_meetup)
  end

  test "unauthenticated access redirects to sign_in" do
    get events_path
    assert_redirected_to new_user_session_path
  end

  test "should get index" do
    sign_in @user
    get events_path
    assert_response :success
  end

  test "should get new" do
    sign_in @user
    get new_event_path
    assert_response :success
  end

  test "should get show" do
    sign_in @user
    get event_path(@event)
    assert_response :success
  end

  test "should create event" do
    sign_in @user
    assert_difference("Event.count") do
      post events_path, params: {
        event: {
          title: "Balade en forêt",
          description: "Randonnée canine organisée dans la forêt de Fontainebleau.",
          city: "Fontainebleau",
          date: 2.weeks.from_now
        }
      }
    end
    assert_response :redirect
  end

  test "should destroy event" do
    sign_in @user
    assert_difference("Event.count", -1) do
      delete event_path(@event)
    end
    assert_redirected_to events_path
  end
end
