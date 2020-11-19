require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest

  def setup
    @base_title = "PhotoTime"
  end

  test "should get top" do
    get root_url
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  test "should get about" do
    get about_url
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "should get contact" do
    get contact_url
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

  # test "should get new" do
  #   get signup_url
  #   assert_response :success
  #   assert_select "title", "Signup | #{@base_title}"
  # end


end
