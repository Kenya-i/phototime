class UsersController < ApplicationController
    def index
    end

    def new
        @user = User.new
    end

    def create
        @user = User.new(users_params)
        if @user.save
          redirect_to users_url
        else
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
