class PostsController < ApplicationController
  def index
    @posts = Post.all
  end

  def show
    @post = Post.find_by(id: params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    # @user = User.find_by(id: session[:user_id])
    #          ↓current_userがあるおかげでログインしていないと投稿できない
    #            (@user.posts.buildと同じ)
    @post = current_user.posts.build(posts_params)
    if @post.save
      flash[:notice] = "投稿しました"
      redirect_to post_url @post
    else
      render "posts/new"
    end
  end


  def destroy
  end



  private

    def posts_params
      params.require(:post).permit(:content, :photo)
    end
   
end
