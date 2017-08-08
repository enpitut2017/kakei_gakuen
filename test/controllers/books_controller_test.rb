require 'test_helper'

class BooksControllerTest < ActionDispatch::IntegrationTest

  setup do
    @book = books(:one)
    @user = users(:one)
  end

=begin
  test "should get index" do
    log_in_as(@user)
    get books_url
    assert_response :success
  end

  test "should get new" do
    get new_book_url
    assert_response :success
  end

  test "should create book" do
    log_in_as(@user)
    assert_difference('Book.count') do
      post books_url, params: { items: ['りんご', 'みかん', 'バナナ'], costs: ['100', '200', '300'], times: ['2017-08-06', '2017-08-07', '2017-08-08'] }
    end

    assert_redirected_to book_url(Book.last)
  end


  test "should show book" do
    get book_url(@book)
    assert_response :success
  end
=end
  #test "should get edit" do
    #get edit_book_url(@book)
    #assert_response :success
  #end

 # test "should update book" do
#    patch book_url(@book), params: { book: { cost: @book.cost, item: @book.item, user_id: @book.user_id, time: @book.time } }
#    assert_redirected_to books_url
 # end

#  test "should destroy book" do
#    assert_difference('Book.count', -1) do
#      delete book_url(@book)
#    end


    assert_redirected_to books_url
  end
=end
end
