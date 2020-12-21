class FollowersController < ApplicationController
    def show
        @user = User.find_by(id: params[:user_id])
        @users = @user.followers
        render 'relationships/followers'
    end
end
