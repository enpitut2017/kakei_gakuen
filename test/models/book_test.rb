require 'test_helper'

class BookTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @book = Book.new(item: "リンゴ", cost: 50000)
  end

  test "should be valid?" do
    assert @book.valid?
  end

  test "item should be present?" do
    @book.item = "  "
    assert_not @book.valid?
  end

  test "cost should be num?" do
    @book.cost = "aaa"
    assert_not @book.valid?
  end
end
