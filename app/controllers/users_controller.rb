class UsersController < ApplicationController

  before_action :build_user, :only => :create
  before_action :validate
  skip_before_action :authenticate_user, :only => :create

	def create
	  success = @user.save
	  if success	
	    respond_to do |format|
	      format.json {
	        render :json => { :success => true, :msg => "Created user" }
	      }
	    end
	  end
	end

	def destroy
	  current_user.delete	
      respond_to do |format|
        format.json {
          render :json => { :success => true, :msg => "deleted user"}
        }
      end
	end

    private

		def user_params
	      params.require(:user).permit(:first_name,:last_name, :email, :password, :phone_number, :address, :vehicle_number,:deliverer)
	    end

	    def build_user
	      @user = User.new(user_params)
	    end

	    def validate
	      user = @user || current_user
	      user.validate_user
	      render :json => {:success => false, :errors => user.errors} if user.errors.present?
	    end

end
