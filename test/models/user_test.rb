require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  #@user.validはバリデーションを通るとture,invalidだと逆に通らないとtureになる

  def setup
    @user = User.new(name: 'foobar', email: 'sample@example.com', budget: 1000, exp:0, level:0, password:'foobar', password_confirmation: 'foobar')
  end

  #正しいユーザーはバリデーションを通る
  test "user validates all" do
    assert @user.valid?
  end

  #名前が50文字以上だと通らない
  test "user validates name" do
    @user.name = "a" * 51
    assert @user.invalid?
  end

  #emailは正しいものを
  test "user validates email" do
    @user.email = "a"
    assert @user.invalid?
  end

  #budgetは整数で
  test "user validates budget" do
    @user.budget = "100a"
    assert @user.invalid?
  end

  #passwordは6文字以上
  test "user validates password" do
    @user.password = "a" * 5
    @user.password_confirmation = @user.password
    assert @user.invalid?
  end

  #passwodとpassword_confirmationは同じでなくてはいけない
  test "user validates passowrd = password_confirmation" do
    @user.password = "difference"
    assert @user.invalid?
  end

  #登録されているemailは使えない(user.ymlのoneがtest@sample.com)
  test "user validates email exists" do
    @user.email = "test@sample.com"
    assert @user.invalid?
  end
end
