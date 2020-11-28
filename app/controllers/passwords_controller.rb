class PasswordsController < ApplicationController
    def edit
        @user = User.find_by(id: params[:id])
    end

    def update
        @user = User.find_by(id: params[:id])
        user = User.find_by(email: current_user.email).try(:authenticate,params[:current_password])
        if user && @user.update(password_params)
            redirect_to root_url
        else
            # redirect_to about_url
            flash.now[:notice] = "失敗しました"
            render :edit
        end
        
    end

    def destroy
    end

    private

        def password_params
            params.require(:user).permit(:password, :password_confirmation)
        end

end
