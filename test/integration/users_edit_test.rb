require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest


  def setup
    @user = users(:ishizuka)
  end


  # ユーザー更新失敗
  test "the case where you could NOT update the user's data(NOT successfull)" do
    # log_in_as(@user)
    post login_path(@user), params: { session: { email: "ishizuka@example.com",
                                                 password: "password"}}
    assert is_logged_in?
    get edit_user_path @user
    assert_template "users/edit"
    data_items = { name:     "a" * 50, # 不適切なデータ
                   email:    "",       # 不適切なデータ
                   username: "",       # 不適切なデータ
                   website:  "https://website.com", # 適切なデータ
                   self_introduce: "", # 
                   tell_number: ""}    # 不適切なデータ

    patch user_path(@user), params: { user: { name:           data_items[:name],
                                             email:          data_items[:email],
                                              username:       data_items[:username],
                                              website:        data_items[:website],
                                               self_introduce: data_items[:self_introduce],
                                              tell_number:    data_items[:tell_number] }}
    assert flash.empty?
    @user.reload
    assert_template "users/edit"
    get root_path
    assert flash.empty?
  end



  # デバッグ中 後でナンバー見る @user.nameの仕組みも見る
  # テスト通る
  test "should" do
    post login_path(@user), params: { session: { email: "ishizuka@example.com",
                                                 password: "password"}}
    assert is_logged_in?
    get edit_user_path @user
    assert_template "users/edit"
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email,
                                              username: @user.username
                                               }}
  end



  # 全データ更新(成功)
  test "the case where you could update ALL the user's data(successfull)" do
    post login_path(@user), params: { session: { email: "ishizuka@example.com",
                                                 password: "password"}}
    assert is_logged_in?
    get edit_user_path @user
    assert_template "users/edit"

    data_items = { name:     "a" * 10,
                   email:    "aaaaaaaa@aaa.com",
                   username: "a" * 10,
                   website:  "https://aaaaaa.com",
                   self_introduce: "a" * 300,
                   tell_number: "080-0000-0000"}

    patch user_path(@user), params: { user: { name:           data_items[:name],
                                              email:          data_items[:email],
                                              username:       data_items[:username],
                                              website:        data_items[:website],
                                              self_introduce: data_items[:self_introduce],
                                              tell_number:    data_items[:tell_number] }}
    assert_not flash.empty?
    assert_redirected_to root_url(@user)
    follow_redirect!
    assert_template "home/top"
    @user.reload
           # データ更新の確認
    assert_equal    data_items[:name],     
                    @user.name
    assert_equal    data_items[:email],   
                    @user.email
    assert_equal    data_items[:username],
                    @user.username
    assert_equal    data_items[:website],
                    @user.website
    assert_equal    data_items[:self_introduce],
                    @user.self_introduce
    assert_equal    data_items[:tell_number],
                    @user.tell_number
    get root_path
    assert flash.empty?
  end

  




  # 3つの必須項目データのみ更新(成功)
  test "the case where you updated ONLY three-required items (successfull)" do
    post login_path(@user), params: { session: { email: "ishizuka@example.com",
                                                 password: "password"}}
    assert is_logged_in?
    get edit_user_path @user
    assert_template "users/edit"

    data_items = { name:     "MouriKogorou",
                   email:    "mouritantei@conan.com",
                   username: "mourikogorou"}

    patch user_path(@user), params: { user: { name:           data_items[:name],
                                              email:          data_items[:email],
                                              username:       data_items[:username]}}
    assert_not flash.empty?
    assert_redirected_to root_url(@user)
    follow_redirect!
    assert_template "home/top"
    @user.reload
            # データ更新の確認
    assert_equal    data_items[:name],     
                    @user.name
    assert_equal    data_items[:email],   
                    @user.email
    assert_equal    data_items[:username],
                    @user.username
    get root_path
    assert flash.empty?
  end

  # 3つの必須項目と空欄の電話番号を更新(成功)
  test "the case where you updated three-required items with BLANK tell_number" do
    post login_path(@user), params: { session: { email: "ishizuka@example.com",
                                                 password: "password"}}
    assert is_logged_in?
    get edit_user_path @user
    assert_template "users/edit"

    data_items = { name: "MouriKogorou",
                   email: "mouritantei@conan.com",
                   username: "mourikogorou",
                   tell_number: ""}

    patch user_path(@user), params: { user: { name: data_items[:name],
                                              email: data_items[:email],
                                              username: data_items[:username],
                                              tell_number: data_items[:tell_number]}}
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_template "home/top"
    @user.reload
    assert_equal    data_items[:name],
                    @user.name
    assert_equal    data_items[:email],
                    @user.email
    assert_equal    data_items[:username],
                    @user.username
    assert_equal    data_items[:tell_number],
                    @user.tell_number
    get root_path
    assert flash.empty?
  end
end
