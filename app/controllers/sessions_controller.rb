class SessionsController < ApplicationController
  # protect_from_forgery :except => [:destroy

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase) 
    if @user&.authenticate(params[:session][:password]) 
      log_in @user
      # session[:user_id] = @user.id
      flash[:success] = "logged in successfully！"
      redirect_to @user
    else
      flash.now[:danger] = "メールアドレスかパスワードが無効です"
      render "new"
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end

  
end





