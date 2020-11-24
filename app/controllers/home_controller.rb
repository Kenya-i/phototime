class HomeController < ApplicationController
  def top
    @users = User.all
  end

  def about 
  end

  def help
  end

  def contact
  end
end
