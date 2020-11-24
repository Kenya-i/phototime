class UsersController < ApplicationController
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

    def show
      @user = User.find(params[:id])
    end

    private
      
      def users_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
      end

end
