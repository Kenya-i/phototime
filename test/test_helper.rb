ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
# require 'carrierwave_helper'

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  parallelize(workers: :number_of_processors)

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here..


  # ログイン済みかどうかをtrue/falseで返す
  # debugger
  def is_logged_in?
    !session[:user_id].nil?
  end

  # ログインするという実際の行動を再現
  # debugger
  def log_in_as(user)
    # debugger
    # post login_path, params: { session: { email: user.email, password: user.password}}
    # session[:user_id] = user.id
  end
  # debugger


end
