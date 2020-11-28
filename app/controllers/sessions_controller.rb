class SessionsController < ApplicationController
  # protect_from_forgery :except => [:destroy

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase) 
    if @user&.authenticate(params[:session][:password]) 
      log_in @user
      # session[:user_id] = @user.id
      flash[:notice] = "ログインしました！"
      redirect_to @user
    else
      flash.now[:notice] = "メールアドレスかパスワードが無効です"
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
