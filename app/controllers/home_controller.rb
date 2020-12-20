class HomeController < ApplicationController
  def top
    if logged_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed
    end
    # @users = User.all 
    # @posts = Post.all
    # @followers ||= current_user.following if logged_in?
    
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
