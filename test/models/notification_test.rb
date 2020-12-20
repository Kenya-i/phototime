require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  def setup
    @notification_one = notifications(:one)
    @notification_two = notifications(:two)
    @notification_three = notifications(:three)
  end

  test "should be valid " do
    assert @notification_one.valid?
    assert @notification_two.valid?
    assert @notification_three.valid?
  end

  test "should not be valid" do
    @notification_one.visitor_id = nil
    assert_not @notification_one.valid?

    @notification_two.visited_id = nil
    assert_not @notification_two.valid?
  end


end
