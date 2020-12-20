require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:ishizuka)
    extend ActionDispatch::TestProcess
    # ↓ なぜか@post = posts(:iphone)でfixturesから呼び出せないので代案として使っている
    file = fixture_file_upload('files/images/炭治郎.jpg', 'image/jpeg')
    @post = @user.posts.build(id: 1, content: "content", photo: file)
    # debugger
    @other_post = posts(:iphone)
  end

  # ログインしていない時は投稿できない
  test "should redirect create when not logged in" do
    assert_no_difference 'Post.count' do
      post posts_path, params: { post: { content: "Lorem ipsum", photo: @post.photo } }
    end
    assert_redirected_to login_url
  end

  # ↓投稿の削除機能はまだ実装していない
  # test "should redirect destroy when not logged in" do
  #   assert_no_difference 'Posts.count' do
  #     delete post_path(@user)
  #   end
  #   assert_redirected_to login_url
  # end


end
