require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true 
  # end

  def setup
    @user = users(:ishizuka)
    @other_user = users(:yamada)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end


  test "should redirect index when not logged in" do
    get users_path
    assert_not flash.empty?
    assert_redirected_to login_url
    follow_redirect!
    assert_not flash.empty?
    assert_template "sessions/new"
    assert_not flash.empty?
  end


  # ログインしていないときに直接editページに行こうとする時
  test "should redirect edit when not logged in" do
    # log_in_as(@other_user)
    get edit_user_path(@user)
    # assert_template "users/edit"
    # 本来であればこの時点でassert_template "users/edit" に向かうはず
    # しかしbefore_actionでログインしていないと "users/edit"　にたどり着かない
    # ように制限をかけることで　login_url へ向かう
    assert_not flash.empty?
    assert_redirected_to login_url
    # before_actionをかけていないと上の3つでさえ成功しない
  end

  # ログインしていないとき直接updataアクションにデータを送る時
  test "should redirect update when not logged in" do
    # post login_path(@other_user), params: { session: { email: @other_user.email,
    #                                                    password: 'password'}}
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email }}
    assert_not flash.empty?
    assert_redirected_to login_url
  end


  test "should redirect edit when logged in as wrong user" do
    # log_in_asの代わり
    post login_path(@other_user), params: { session: { email: @other_user.email,
                                                       password: 'password' }}
    assert_not flash.empty?
    assert is_logged_in?
    assert_redirected_to user_url(@other_user.id)
    follow_redirect!
    assert_template "users/show" #ここでflashが表示されている
    assert_not flash.empty?
    # ここまでlog_in_asの代わり
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
    # log_in_asの代わり
    post login_path(@other_user), params: { session: { email: @other_user.email,
                                                       password: 'password' }}
    assert_not flash.empty?
    assert is_logged_in?
    assert_redirected_to user_url(@other_user.id)
    follow_redirect!
    assert_template "users/show" #ここでflashが表示されている
    # ここまでlog_in_asの代わり
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email }}
    assert flash.empty?
    assert_redirected_to root_url

  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  
end
