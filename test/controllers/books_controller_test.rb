require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest

  setup do
    @book = books(:one)
    @user = users(:one)
  end
end
