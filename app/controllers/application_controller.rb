class ApplicationController < ActionController::Base
    def top
    end

    include SessionsHelper

    def logged_in_user
        #ログインしてたら何もしない
        unless logged_in?
        #ログインしてなかったら以下を行う
          flash[:danger] = "Please log in."
          redirect_to login_url
        end
    end

    
end
