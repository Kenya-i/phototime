require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    # @user = User.new(name: "Ex User",            email: "exuser@example.com",
    #                  password: "password",       password_confirmation: "password",
    #                  username: "Kenya",          website: "https://website-example.com",
    #                  self_introduce: "a" * 300 , tell_number: "080-1234-5678"   )
    @user = users(:ishizuka)
    # ↓ユーザーが削除されたら投稿も削除されるかどうかの確認用
    @sample_user = User.new(name: "sample user", email: "sample@user.com",
                            password: "password", password_confirmation: "password")
    @other_user = users(:yamada)
  end

  # test "user2" do
  #   assert @user2.valid?
  # end

  # test "user2 image" do
  #   @user2.image = nil
  #   assert @user2.valid?
  # end

  # ユーザー自体の保存の可否
  test "should be valid" do
    @user = users(:ishizuka)
    assert @user.valid?
  end

  # 名前が空欄では保存されない
  test "name should be presence" do
    @user.name = "  "
    assert_not @user.valid?
  end

  # メールが空欄では保存されない
  test "email should be presence" do
    @user.email = "   "
    assert_not @user.valid?
  end

  # 名前が50字を超えると保存されない(保存は50字まで)
  test "name should be  not too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  # メールが255字を超えると保存されない(保存は255字まで)
  test "email should be not too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  # emailの有効性のテスト(有効)
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com User@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?
    end
  end

  # eamilの有効性のテスト(無効)
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. 
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?
    end
  end

  # 一意性の検証
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  # パスワードが空欄では保存されない
  test "password should be present (nonblank)" do
    @user.password = " " * 6
    @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  # パスワードが5文字以下だと保存されない(6文字以上が有効)
  test "password should have a minimum length" do
    @user.password = "a" * 5 
    @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  # ユーザーネームが空欄では保存されない
  test "username should be present" do
    @user.username = "  "
    assert_not @user.valid? 
  end

  # ユーザーネームは20字を超えると保存されない(保存は20字まで)
  test "username should not be too long" do
    @user.username = "a" * 21
    assert_not @user.valid?
  end

  # ウェブサイトは空欄でも保存できる(必須項目ではない)
  test "website can be blank" do
    @user.website = "  "
    assert @user.valid?
  end

  # ウェブサイトは255字を超えると保存されない(保存は255字まで)
  test "website should not be too long" do
    @user.website = "a" * 256
    assert_not @user.valid?
  end

  # 自己紹介文は空欄でも保存できる(必須項目ではない)
  test "self_introduce can be blank" do
    @user.self_introduce = " "
    assert @user.valid?
  end

  # 自己紹介文は300字を超えると保存されない(保存は300字まで)
  test "self_introduce should not be too long" do
    @user.self_introduce = "a" * 301
    assert_not @user.valid?
  end

  # test "tell_number should include 11 numbers 3 hyphens" do
  #   @user.tell_number = "080" + "-" + ("0" * 4) + "-" + ("0" * 4)
  #   assert @user.valid?
  # end

  # 電話番号の有効性のテスト(有効)
  test "tell_number validation should accept valid number" do
    valid_numbers = %w[050-1234-5678 060-0000-0000 070-5364-9801
                        080-8765-4321 090-1111-9999]
    valid_numbers.each do |valid_number|
      @user.tell_number = valid_number
      assert @user.valid?
    end
  end

  # 電話番号の有効性のテスト(無効)
  test "tell_number validation should reject invalid number" do
    invalid_numbers = %w[150-1234-5678 020-2222-2222 069-1234-5678
                        340-4248-4793 039-9876-5432 555-7939-1749
                        343-0000-0000]
    invalid_numbers.each do |invalid_number|
      @user.tell_number = invalid_number
      assert_not @user.valid?
    end
  end

  # ユーザー画像は無くても良い
  test "image doesn't always have to be attached " do
    @user.image = nil
    # debugger
    assert @user.valid?
  end

  # ユーザーが削除された時投稿も削除される
  test "associated posts should be destroyed" do
    @sample_user.save
    extend ActionDispatch::TestProcess
    file = fixture_file_upload('files/images/アイコン.jpg', 'image/jpeg')
    @sample_user.posts.create!(content: "sample user!", photo: file)
    assert_difference 'Post.count', -1 do
      @sample_user.destroy
    end
  end

  test "should follow and unfollow a user" do
    ishizuka = users(:ishizuka)
    yamada = users(:yamada)
    assert_not ishizuka.following?(yamada)
    ishizuka.follow(yamada)
    assert ishizuka.following?(yamada)
    assert yamada.followers.include?(ishizuka)
    ishizuka.unfollow(yamada)
    assert_not ishizuka.following?(yamada)
  end

  test "feed should have the right posts" do
    ishizuka = users(:ishizuka)
    yamada   = users(:yamada)
    matsuda    = users(:matsuda)
    # フォローしているユーザーの投稿を確認
    matsuda.posts.each do |post_following|
      assert ishizuka.feed.include?(post_following)
    end
    # 自分自身の投稿を確認
    ishizuka.posts.each do |post_self|
      assert ishizuka.feed.include?(post_self)
    end
    # フォローしていないユーザーの投稿を確認
    yamada.posts.each do |post_unfollowed|
      assert_not ishizuka.feed.include?(post_unfollowed)
    end
  end



end

