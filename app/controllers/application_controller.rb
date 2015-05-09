class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery { request.format.json? }
  
  skip_before_filter :verify_authenticity_token

  helper_method :current_user_session, :current_user

  before_action :authenticate_user

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session && current_user_session.user
    end

    def authenticate_user
      authenticate_with_http_token do |token, option|
        @current_user = User.find_by_single_access_token(Base64.decode64(token))
      end
      render :json => {:access_denied => true} unless @current_user
    end
end