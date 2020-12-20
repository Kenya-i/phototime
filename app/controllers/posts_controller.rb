class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create] # destroyなし


  def index
    @posts = Post.all
  end

  def show
    @post = Post.find_by(id: params[:id])
    @comments = @post.comments
    @comment = Comment.new
    # @like = Like.new
  end

  def new
    @post = Post.new
  end

  def create
    # @user = User.find_by(id: session[:user_id])
    #          ↓current_userがあるおかげでログインしていないと投稿できない
    #            (@user.posts.buildと同じ)
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "posted your photo successfully!"
      redirect_to post_url @post
    else
      render "posts/new"
    end
  end


  # destroyなし
  def destroy
  end

  def search
    @word = params[:search]
    @posts = Post.search(params[:search])
  end



  private

    def post_params
      params.require(:post).permit(:content, :photo)
    end
   
end
