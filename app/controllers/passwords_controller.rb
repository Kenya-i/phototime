class PasswordsController < ApplicationController
    before_action :logged_in_user, only: [:edit, :update]
    before_action :correct_user, only: [:edit, :update]


    def edit
        # @user = User.find_by(id: params[:user_id])
    end

    def update
        @user = User.find_by(id: params[:user_id])
        user = User.find_by(email: @user.email).try(:authenticate,params[:current_password])
        if user && @user.update(password_params)
            redirect_to root_url
        else
            # redirect_to about_url
            flash.now[:danger] = "failed to update..."
            render :edit
        end
        
    end

    def destroy
    end

    private

        # def current_password_params
        #     params.permit(:current_password)
        # end

        def password_params
            params.require(:user).permit(:password, :password_confirmation)
        end

        def correct_user
            @user = User.find_by(id: params[:user_id])
            redirect_to(root_url) unless current_user? @user
        end

end
