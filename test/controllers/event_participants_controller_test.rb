require "test_helper"

class EventParticipantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user  = users(:alice)
    @event = events(:dog_meetup)
  end

  test "unauthenticated create redirects to sign_in" do
    post event_event_participants_path(@event)
    assert_redirected_to new_user_session_path
  end

  test "should create event_participant" do
    sign_in @user
    other_event = Event.create!(
      title: "Test event",
      description: "Rencontre canine dans un parc de la ville pour les chiens sociables.",
      city: "Lyon",
      date: 1.week.from_now,
      dog: dogs(:rex)
    )
    assert_difference("EventParticipant.count") do
      post event_event_participants_path(other_event)
    end
    assert_response :redirect
  end

  test "should destroy event_participant" do
    sign_in @user
    assert_difference("EventParticipant.count", -1) do
      delete event_event_participant_path(@event, event_participants(:rex_at_meetup))
    end
    assert_response :redirect
  end
end
