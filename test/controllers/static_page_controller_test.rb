require 'test_helper'

class StaticPageControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get static_page_index_url
    assert_response :success
  end

end
