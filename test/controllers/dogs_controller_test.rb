require "test_helper"

class DogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:alice)
    @dog  = dogs(:rex)
  end

  test "unauthenticated access redirects to sign_in" do
    get dogs_path
    assert_redirected_to new_user_session_path
  end

  test "should get index" do
    sign_in @user
    get dogs_path
    assert_response :success
  end

  test "should get new" do
    sign_in @user
    get new_dog_path
    assert_response :success
  end

  test "should get show" do
    sign_in @user
    get dog_path(@dog)
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get edit_dog_path(@dog)
    assert_response :success
  end

  test "should create dog" do
    sign_in @user
    assert_difference("Dog.count") do
      post dogs_path, params: {
        dog: {
          name: "Fido",
          breed: "Dalmatien",
          age: 4,
          gender: "Mâle",
          description: "Un chien très vif et plein d'énergie, adorable avec tous."
        }
      }
    end
    assert_response :redirect
  end

  test "should update dog" do
    sign_in @user
    patch dog_path(@dog), params: { dog: { name: "Rex II" } }
    assert_redirected_to dog_path(@dog)
  end

  test "should destroy dog" do
    sign_in @user
    deletable = Dog.create!(
      name: "Temp",
      breed: "Berger",
      age: 1,
      description: "Chien temporaire créé uniquement pour ce test.",
      user: @user
    )
    assert_difference("Dog.count", -1) do
      delete dog_path(deletable)
    end
    assert_redirected_to dogs_path
  end
end
