require 'test_helper'

class UsesProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:ishizuka)
    @other_user = users(:yamada)
    # extend ActionDispatch::TestProcess
    # file = fixture_file_upload('files/images/アイコン.jpg', 'image/jpeg')
    # @post = @user.posts.build(id: 1, content: "content", photo: file)

  end

  # ログインして自分のプロフィールページに行った時の画面表示
  test "the case where you logged in followed by getting to YOUR profile page" do
    post login_path(@user), params: { session: { email: @user.email,
                                                       password: 'password' }}
    assert_not flash.empty?
    assert is_logged_in?
    follow_redirect!
    assert_template 'users/show'
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select '.user-name', text: @user.name
    assert_select '.user-icon>.user-name>img', count: 1
    assert_select '.user-icon>.user-name>img[src=?]','/assets/アイコン-1f66430508e2bf6ea7f0c209bb56c03b10829ebacb7663946ea564c53dcef7ce.jpg'
    assert_match @user.posts.count.to_s, response.body
    assert_select '.self-introduce-wrapper', text: @user.self_introduce
    assert_select '.user-profile-edit>a', text: "プロフィールを編集する"
    assert_select '.user-profile-edit>a[href=?]', edit_user_path(@user), count: 1
    assert_select '.posts-count', text: "#{@user.posts.count}件の投稿"
    # プロフィール画像変更後、プロフィールページの画面表示を確認
    get edit_user_path(@user)
    assert_template 'users/edit'
    file = fixture_file_upload('files/images/星空.jpg', 'image/jpeg')
    # debugger
    data_items = { name:     "a" * 10,
                   email:    "aaaaaaaa@aaa.com",
                   username: "a" * 10,
                   website:  "https://aaaaaa.com",
                   self_introduce: "a" * 300,
                   tell_number: "080-0000-0000",
                   image: file}

                 
    patch user_path(@user), params: { user: { name:           data_items[:name],
                                              email:          data_items[:email],
                                              username:       data_items[:username],
                                              website:        data_items[:website],
                                              self_introduce: data_items[:self_introduce],
                                              tell_number:    data_items[:tell_number],
                                              image:          data_items[:image] }}
    assert_not flash.empty?
    assert_redirected_to root_url
    follow_redirect!
    assert_template "home/top"
    @user.reload
    get user_path(@user)
    assert_template 'users/show'
    # debugger
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
    

    # アイコンが変更されているか確認
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select '.user-name', text: @user.name
    assert_select '.user-icon>.user-name>img', count: 1
    assert_select '.user-icon>.user-name>img[src=?]', "/uploads/user/image/1/%E6%98%9F%E7%A9%BA.jpg" # 星空に変更されている
  end

  # ログインして他人のプロフィールページに行った時の画面表示
  test "the case where you logged in followed by getting to others profile pages" do
    post login_path(@user), params: { session: { email: @user.email,
                                                 password: 'password' }}
    assert_not flash.empty?
    # get user_path(@user)
    assert is_logged_in?
    follow_redirect!
    assert_template 'users/show' #@userのプロフィール画面
    get user_path(@other_user)
    assert_select 'title', full_title(@other_user.name)
    assert_select '.user-name', text: @other_user.username
    assert_select '.user-icon>.user-name>img', count: 1
    assert_select '.user-icon>.user-name>img[src=?]','/assets/アイコン-1f66430508e2bf6ea7f0c209bb56c03b10829ebacb7663946ea564c53dcef7ce.jpg'
    assert_match @other_user.posts.count.to_s, response.body
    assert_select '.self-introduce-wrapper', text: @other_user.self_introduce
    assert_select '.user-profile-edit>a', text: "プロフィールを編集する", count: 0
    assert_select '.user-profile-edit>a[href=?]', edit_user_path(@user), count: 0
    assert_select '.posts-count', text: "#{@other_user.posts.count}件の投稿"
  end

  # ログインせずにプロフィールページに行く
  test "can get to profile page without login" do
    get user_path(@user)
    assert !is_logged_in?
    assert_template 'users/show'
    assert_select '.main-wrapper>.image', count: 0
  end

  # # 同じユーザーがログインせずに自分のページを見に行く
  # get user_path(@other_user)
  # assert_template 'users/show'
  # #           # ↓sessionが貼ってあればjQuery機能は無いはずなのでここでエラーになる
  # assert_select '.main-wrapper>.image', count: 0
  # assert_match @other_user.name , response.body 
  # assert_select '.user-name', text: @other_user.name # yamada
  # assert_select '.user-icon>img[src=?]','/assets/アイコン-1f66430508e2bf6ea7f0c209bb56c03b10829ebacb7663946ea564c53dcef7ce.jpg'
  # # ↓自分がログインせずにアプリケーションを開く
  # # get post_path(@other_user.posts[0])
  # # assert_template "posts/show"
  # # assert !is_logged_in?
  # #           # ↓sessionが貼ってあればjQuery機能は無いはずなのでここでエラーになる
  # # assert_select '.main-wrapper>.image', count: 0
  # # assert_select '.main-wrapper>.container>img', count: 1
  # # assert_select '.user-post-text', count: 1
  # # # assert_select '.main-wrapper>.image', count: 1
  # # # assert_select '.main-wrapper>.container>.user-post-image', count: 1
  # # assert_match "/uploads/post/photo/1063225355/%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3.jpg", response.body
  # # assert_match "今日はプログラミングを勉強しました", response.body

end
