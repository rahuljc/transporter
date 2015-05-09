class UserSessionsController < ApplicationController

	skip_before_action :authenticate_user, :only => :create

	def create
		#validate if the user exists
		user_session_params = params[:user_session]
	    email = user_session_params[:email]
	    password = user_session_params[:password]
	    @user = User.find_by_email(email)


	    if @user #if user found create session
		    user_session = UserSession.new(:email => email, :password => password)
		    success = user_session.save
		    message = { :success => success }
		else
			message = { :error_code => "Invalid credentials" }		
		end

	    respond_to do |format|
	      format.json {
	        render :json => message
	      }
	    end
	end

end
