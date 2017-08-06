require 'test_helper'

class BookTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @book = Book.new(item: 'リンゴ', cost: 200, time: '2017-8-6', user: users(:one))
  end

  test "book validates all" do
    assert @book.valid?
  end

  #item名は必須
  test "book validates item requier" do
    @book.item = ""
    assert @book.invalid?
  end

  #costは必須
  test "book validates cost requier" do
    @book.cost = ""
    assert @book.invalid?
  end

  #costは数値である
  test "book validates cost numeric" do
    @book.cost = "100a"
    assert @book.invalid?
  end

  #timeは必須である
  test "book validates time require" do
    @book.time = ""
    assert @book.invalid?
  end
end
