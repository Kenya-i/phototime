require 'test_helper'

class UsersPostPageTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:ishizuka)
  end


  # ログインせずに投稿ページを訪れる場合
  # (ログインしていない状態で検索窓に直接posts/1"と書き込んだら、投稿ページにはjquery機能はないはず)
  test "profile page and post don't have jQuery function when not logged in" do
    # ↓ログインして画像を投稿だけしてその後ログアウト↓
    post login_path, params: { session: { email: @user.email,
                                                 password: 'password' }}
    assert_not flash.empty?
    assert is_logged_in?
    follow_redirect!
    assert_template 'users/show'
    get new_post_path
    assert_select 'input[type=file]', count: 1
    assert_select 'textarea', count: 1
              # 無効な送信
    title = "今日はプログラミングを勉強しました。"
    assert_difference 'Post.count', 0 do
      post posts_path, params: { post: {content: title
                                        } }                
    end
              # 有効な送信
    assert_template 'posts/new'
    # ↓sessionが貼ってあればjQuery機能は無いはず
    assert_select '.main-wrapper>.image', count: 0
    file = fixture_file_upload('files/images/アイコン.jpg', 'image/jpeg')
    # debugger
    assert_difference 'Post.count', 1 do
      post posts_path, params: { post: {content: title,
                                          photo: file } }                                
    end
    assert_redirected_to post_url(@user.posts[0]) # @user.posts[0].id
    follow_redirect!
    assert_template 'posts/show'
              # 投稿した個別ページの画面チェック # post = assigns(:post)
              # ↓                           # assert post.file?
              # ↓sessionが貼ってあればjQuery機能は無いはず
    assert_select '.main-wrapper>.image', count: 0
    assert_select '.user-post-text', count: 1
    assert_match "/uploads/post/photo/1063225355/%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3.jpg", response.body
    assert_match title, response.body
    delete logout_path(@user)
    assert !is_logged_in?
    # ↑ここまで(ログアウト)
    # ログインせずに投稿を見に行く
    get post_path(@user.posts[0])
    assert !is_logged_in?
    assert_template 'posts/show'
    #           # ↓sessionが貼ってあれば(ログインしていれば)jQuery機能は無いはずなのでここでエラーになる
    assert_select '.main-wrapper>.image', count: 0
    assert_select '.user-post-text', count: 1
    assert_match "/uploads/post/photo/1063225355/%E3%82%A2%E3%82%A4%E3%82%B3%E3%83%B3.jpg", response.body
    assert_match title, response.body
  end


  # ログインしていないと新規投稿ページに行けない
  test "should redirect posts when not logged in" do
    get new_post_path
    assert !is_logged_in?
    assert_redirected_to login_path
    assert_not flash.empty?
  end

end
