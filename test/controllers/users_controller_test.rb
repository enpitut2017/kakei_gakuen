require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.new(:one)
  end


  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { budget: 1000, email: 'example@sample.com', coin: 0, name: 'example', password: 'foobar', password_confirmation: 'foobar' } }
    end

    assert_redirected_to user_url(User.last)
  end
  
end
