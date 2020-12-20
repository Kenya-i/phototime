require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:ishizuka)
  end

  test "login with invalid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: "", 
                                          password: "" }}
    assert !is_logged_in?
    assert_template "sessions/new"
    assert_not is_logged_in?
    assert_not flash.empty?
    get root_path
    assert flash.empty?
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
  end


  test "login with valid information" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: @user.email,
                                          password: 'password'}}
    assert is_logged_in? #
    assert_not flash.empty? #
    assert_redirected_to user_path(@user.id)
    follow_redirect!
    # redirectした直後のテンプレートでflashが消えると勘違いしていた。
    # 直後のテンプレートではflashは存在し、次のページ移動でflashが消える
    assert_template "users/show" # ここでflashが表示されている
    assert_not flash.empty? #"users/edit"をまだ表示中なのでflashが存在する。
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "form[action=?]", logout_path
    assert_select "a[href=?]", edit_user_path
    assert_select "a[href=?]", login_path, count: 0
    get edit_user_path(@user) # ここでgetを送るので
    assert flash.empty? #やっとflashが空になる　
  end




  test "login with valid email/invalid password" do
    get login_path
    assert_template "sessions/new"
    post login_path, params: { session: { email: @user.email,
                                          password: "invalidpassword"}}
    assert_not is_logged_in?
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information followed by logout" do
    get login_path
    post login_path, params: { session: {email: @user.email,
                                        password: "password"}}
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", user_path(@user)
    assert_select "form[action=?]", logout_path
    assert_select "a[href=?]", edit_user_path
    assert_select "a[href=?]", login_path, count: 0
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_url
    follow_redirect!
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", login_path
    assert_select "form[action=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0
  end



  # test "couldn't log in when have already logged in" do
  #   post login_path, params: { session: { email: @user.email,
  #                                         password: "password"}}
  #   assert is_logged_in?
  #   get login_path
  #   assert_template 'users/show'
  # end

end
