class FollowingsController < ApplicationController
    def show
        @user = User.find_by(id: params[:user_id])
        @users = @user.following
        render 'relationships/following'
    end
end
