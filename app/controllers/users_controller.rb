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
          flash[:success] = "ユーザーを作成しました！"
          redirect_to users_url
        else
          flash[:danger] = "ーユーザー作成に失敗しました"
          render "new"
        end
    end

    def show
    end

    private
      
      def users_params
        params.require(:user).permit(:name, :email)
      end

end
