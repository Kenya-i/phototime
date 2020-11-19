require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = User.new(name: "Ex User", email: "exuser@example.com",
                     password: "password", password_confirmation: "password")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be presence" do
    @user.name = "  "
    assert_not @user.valid?
  end

  test "email should be presence" do
    @user.email = "   "
    assert_not @user.valid?
  end

  test "name should be  not too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should be not too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # emailの有効性のテスト(有効)
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com User@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?
    end
  end

  #eamilの有効性のテスト(無効)
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. 
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?
    end
  end

  #一意性の検証
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  #パスワード
  test "password should be present (nonblank)" do
    @user.password = " " * 6
    @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = "a" * 5 
    @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end
end
