class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :correct_user_with_follow_function, only: [:following, :followers]

  def index
    @users = User.all
    @posts = Post.all
  end

  def new
      @user = User.new
  end

  def show
    # debugger
    @user = User.find(params[:id])
    @posts = @user.posts
    # debugger
  end

  def create
      @user = User.new(users_params)
      if @user.save
        log_in @user
        flash[:success] = "Created your account！"
        redirect_to @user
      else
        flash.now[:danger] = "falied to create your account…"
        render "new"
      end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(users_params)
      flash[:success] = "updated your information successfully!"
      redirect_to root_url
    else
      render "users/edit"
    end
  end

  
  
  def destroy
    @user = User.find_by(id: params[:id])
    if @user.destroy
      flash[:success] = "Deleted your account successfully!"
      redirect_to root_url
    else
      flash[:danger] = "failed to delete your account..."
      render root_path
    end
  end


  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following
    render 'relationships/following'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers
    render "relationships/followers"
  end

  

  private
    
    def users_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation,
                                   :username, :website, :self_introduce,
                                   :tell_number, :image, :sex)
    end


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user? @user
    end

    def correct_user_with_follow_function
      if current_user
        @user = User.find_by(id: params[:id])
        redirect_to user_path(current_user) unless current_user? @user
      end
    end

end
