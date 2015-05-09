class RequestsController < ApplicationController

	def index
	    respond_to do |format|
	      format.json {
	        render :json => {:message=>"All requests"}
	      }
	    end 		
	end

	def create
	    respond_to do |format|
	      format.json {
	        render :json => {:message=>"created requests"}
	      }
	    end		
	end

	def destroy
	    respond_to do |format|
	      format.json {
	        render :json => {:message=>"destroy requests"}
	      }
	    end		
	end

	def status
	    respond_to do |format|
	      format.json {
	        render :json => {:message=>"get status from android"}
	      }
	    end		
	end
end
