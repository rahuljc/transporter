class UserSessionsController < ApplicationController

	skip_before_action :authenticate_user, :only => :create

	DEVICE_UUID_ERROR = 1
	INVALID_CREDENTIALS = 2

	def create
		#validate if the user exists
		user_session_params = params[:user_session]
	    email = user_session_params[:email]
	    password = user_session_params[:password]
	    @user = User.find_by_email(email)
	    message = {}

	    if @user #if user found create session
		    user_session = UserSession.new(:email => email, :password => password)
		    success = user_session.save
		    if success
		      is_saved = save_device
		      message[:success] = is_saved 
		      if is_saved
		        message[:api_key] = @user.single_access_token
		        message[:user] = @user.info
		      else
		        message[:error_code] = DEVICE_UUID_ERROR
		      end
		    else
		    	message[:error_code] = INVALID_CREDENTIALS
		    end
		else
			message[:error_code] = INVALID_CREDENTIALS
		end

	    respond_to do |format|
	      format.json {
	        render :json => message
	      }
	    end
	end

  private

    def save_device
        return false if params[:user_session][:device].blank?
        device_params = params[:user_session][:device]
        device_uuid = device_params[:device_uuid]

        return false if device_uuid.blank?
        return true if @user.devices.find_by_device_uuid(device_uuid)
        return false if Device.find_by_device_uuid(device_uuid)

        device_params = ActionController::Parameters.new({:device_uuid => device_uuid}).permit(:device_uuid)
        @user.devices.build(device_params)
        @user.save
    end
end