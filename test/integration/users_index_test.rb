require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:ishizuka)
  end

  test "index" do
    # log_in_as(@user)
  end
end
