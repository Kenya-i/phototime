require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # def setup
  #   @user = users(:ishizuka)

  # end

  test "invalid signup information" do
    get signup_path
    assert_no_difference "User.count" do
      post users_path, params: { user: {name: " ",
                                        email: "user@invalid",
                                        username: "ssssss",
                                        password: "foobar",
                                        password_confirmation: "foobar" }}
    end
    assert_not is_logged_in?
    assert_not flash.empty?
    assert_template "users/new"
    get root_path
    assert flash.empty?
  end

  test "valid signup information" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: {name: "kkkkkk",
                                        email: "kkkkkk@kkk.kkk",
                                        username: "kkkkkk",
                                        password: "kkkkkk",
                                        password_confirmation: "kkkkkk"}}
    end
    assert is_logged_in?
    follow_redirect!
    assert_template "users/show"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end
end
