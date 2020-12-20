require 'test_helper'

class PostTest < ActiveSupport::TestCase


  def setup
    @user = users(:ishizuka)
    extend ActionDispatch::TestProcess
    # ↓ なぜか@post = posts(:iphone)でfixturesから呼び出せないので代案として使っている
    file = fixture_file_upload('files/images/炭治郎.jpg', 'image/jpeg')
    @post = @user.posts.build(content: "content", photo: file)
  end


  test "should be valid" do
    assert @post.valid?
  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test "content should be present" do
    @post.content = ""
   
    assert_not @post.valid?
  end

  test "content should be at most 140 characters" do
    @post.content = "a" * 141
    assert_not @post.valid?
  end

  test "photo should be present" do
    # @post.photo = nil
    @post.remove_photo!
    assert_not @post.valid?
  end

  test "order should be most recent first" do
    assert_equal posts(:most_recent), Post.first
  end

end
