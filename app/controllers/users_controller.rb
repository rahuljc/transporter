class UsersController < ApplicationController

	def create
      respond_to do |format|
        format.json {
          render :json => { :success => true, :msg => "Created user" }
        }
      end
	end

	def update
      respond_to do |format|
        format.json {
          render :json => { :success => true, :msg => "updated user" }
        }
      end
	end

	def destroy
      respond_to do |format|
        format.json {
          render :json => { :success => true, :msg => "deleted user"}
        }
      end
	end	
end
