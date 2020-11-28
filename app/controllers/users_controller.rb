class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def new
      @user = User.new
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
    # debugger
    if @user.update(users_params)
      flash[:notice] = "ユーザー情報を更新しました!"
      redirect_to root_url
    else
      flash.now[:notice] = "ユーザー情報の更新に失敗しました"
      render "users/new"
    end
  end

  
  def destroy
    @user = User.find_by(id: params[:id])
    if @user && @user.destroy
    else
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private
    
    def users_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :username, :website, :self_introduce, :tell_number)
    end

    def logged_in_user
      #ログインしてたら何もしない
      unless logged_in?
      #ログインしてなかったら以下を行う
        flash[:notice] = "Please log in."
        redirect_to login_url
      end
    end


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user? @user
    end


end
