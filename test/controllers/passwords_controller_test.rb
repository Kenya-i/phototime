require 'test_helper'

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    @user = users(:ishizuka)
    @other_user = users(:yamada)
  end

  # ログインしてパスワードを変更する
  test "current_user" do
    
  end


  # ログインせずにパスワード変更ページに行こうとする(たどり着かない)
  test "current user without login" do
    get edit_user_password_path(@user)
    assert !is_logged_in?
    assert_redirected_to login_path
    assert_not flash.empty?
  end

  # ログインしていても他人のパスワード変更ページには行けない
  # test "a" do
  #   new_password = "newpassword"
  #   patch edit_user_password_path(@user), params: { current_password: @user.password}
  #   patch edit_user_password_path(@user), params: { user: { password: new_password,
  #                                                           password_confirmation: new_password }}                                                        
  #   assert_template 'users/show'
  #   asssert is_logged_in?

  # end

  # 直接postを送ってパスワードを変更することはできない

end
