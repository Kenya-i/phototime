class HomeController < ApplicationController
  def top
    if logged_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed
    end
  end

  def about 
  end

  def help
  end

  def contact
  end

  def terms
  end
  
end
