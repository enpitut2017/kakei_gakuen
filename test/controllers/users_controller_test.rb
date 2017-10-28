require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end


  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { budget: 1000, email: 'example@sample.com', coin: 0, name: 'example', password: 'foobar', password_confirmation: 'foobar' } }
    end

    assert_redirected_to user_url(User.last)
  end

end
