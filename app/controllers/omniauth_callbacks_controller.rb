class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    
    def facebook
        callback_from(:facebook)
    end

    # def google_oauth2
    #     callback_for(:google)
    # end

    # def callback_for(provider)
    #     @omniauth = request.env['omniauth.auth']
    #     info = User.find_oauth(@omniauth)
    #     @user = info[:user]
    #     if @user.persisted?
    #         sign_in_and_redirect @user, event: :authentication
    #         set_flash_message(:notice, :success, kind: "#{provider}".capitalize) if is_navigational_format?
    #     else
    #         @sns = info[:sns]
    #         render template: "devise/registrations/new"
    #     end
    # end

    # def failure
    #     redirect_to root_path and return
    # end

    def callback_from(provider)
        provider = provider.to_s
    
        @user = User.find_for_oauth(request.env['omniauth.auth'])
    
        if @user.persisted?
          flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: provider.capitalize)
          sign_in_and_redirect @user, event: :authentication
        else
          session["devise.#{provider}_data"] = request.env['omniauth.auth']
          redirect_to new_user_registration_url
        end
    end



end