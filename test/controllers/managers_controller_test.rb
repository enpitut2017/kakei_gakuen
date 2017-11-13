require 'test_helper'

class ManagersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get managers_new_url
    assert_response :success
  end

end
