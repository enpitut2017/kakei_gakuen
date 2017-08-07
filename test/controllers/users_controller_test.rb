require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:one)
    @other_user = users(:two)
    @no_books_user = users(:three)
  end

  test "should get index" do
    get root_path
    assert_response :success
  end

  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: { user: { budget: 1000, email: 'example@sample.com', exp: 0, level: 0, name: 'example', password: 'foobar', password_confirmation: 'foobar' } }
    end

    assert_redirected_to user_url(User.last)
  end

  test "should show user" do
    get user_url(@user)
    @lost = 0
    @rest = 0
    books = Book.where(user: @user)

    #@userの持っている数だけ取得できているかのテスト
    assert_equal books.size, 2

    #booksがすべて@userのものかをテスト
    books.each do |book|
      assert_equal book.user, @user
    end

    #出費の計算ができているかをテスト
    assert_difference('@lost', 400) do
      books.each do |book|
        @lost += book.cost
      end
    end

    #残高の計算ができているかをテスト
    assert_difference('@rest', 600) do
      @rest = @user.budget - @lost
    end

    assert_response :success
  end

  test "should show user has collect books" do
    get user_url(@user)
    bad_books = Book.where(user: @other_user)
    bad_books.each do |book|
      assert_not_equal book.user, @user
    end
    assert_response :success
  end

  test "should show user has no books" do
    get user_url(@no_books_user)
    books = Book.where(user: @no_books_user)
    assert_equal books.size, 0
    assert_response :success
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end
    assert_redirected_to users_url
    return
  end

  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { budget: 1000, email: 'example@sample.com', exp: 0, level: 0, name: 'example', password: 'foobar', password_confirmation: 'foobar' }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end
=begin
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { budget: 1000, email: 'example@sample.com', exp: 0, level: 0, name: 'example', password: 'foobar', password_confirmation: 'foobar' }}
    assert flash.empty?
    assert_redirected_to root_url
  end
=end
end
