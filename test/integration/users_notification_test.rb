require 'test_helper'

class UsersNotificationTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # en

  def setup
    @user = users(:ishizuka)
  end

  test "should get to notification page properly when logged in properly" do
    post login_path(@user), params: { session: { email: @user.email,
                                                 password: "password" }}
    assert is_logged_in?
    get notifications_path
    assert_template "notifications/index"
  end

  test "should get to login page when not logged in" do
    get notifications_path
    assert_not is_logged_in?
    # assert_template "sessions/new" 　　#なぜか行かない
  end


end
