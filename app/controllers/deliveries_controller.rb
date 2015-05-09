class DeliveriesController < ApplicationController

  before_action :disallow_requester
  before_action :build_device

	def assign
	    @request = Request.where({:status => Request::STATUS_BY_KEY[:open]}).where(
	                  ["FIND_IN_SET(:device_id, nearest_deliverers) > 0",
	                  {:device_id => @device.id}]).first

	    if @request
	      @request.status = Request::STATUS_BY_KEY[:assigned]
	      @device.requests << @request

	      if @request.device and @device.create_engaged_deliverer(:request_id => @request.id)
	        receiver  = @request.receiver
	        requester = @request.requester
	        picked_up_location = Location.find_by_id(@request.pickup_location_id)
	        drop_location = Location.find_by_id(@request.drop_location_id)

	        respond_to do |format|
	          format.json {
	            render :json => {:success => true,
	                :request => {:id => @request.id, :status => @request.status, :distance => @request.distance},
	                :receiver => {:name => receiver.name, :phone_number => receiver.phone_number,
	                              :order_id => receiver.order_id },
	                :requester => {:name => requester.first_name, :phone_number => requester.phone_number},
	                :picked_up_location => {:lattitude => picked_up_location.lattitude, 
	                              :longitude => picked_up_location.longitude, :address => picked_up_location.address},
	                :drop_location => {:lattitude => drop_location.lattitude, :longitude => drop_location.longitude,
	                              :address => drop_location.address }
	                            }
	          }
	        end
	      else
	        respond_to do |format|
	          format.json {
	            render :json => {:success => false}
	          }
	        end
	      end
	    else
	      respond_to do |format|
	        format.json {
	          render :json => {:success => false}
	        }
	      end
	    end
	end

  	def picked_up
    	success = false
    	@request = @device.requests.where( :id => params[:request][:id],
                  	:status => Request::STATUS_BY_KEY[:assigned]).first
    	if @request.present?
      	@request.status = Request::STATUS_BY_KEY[:picked_up]
      	success = @request.save

      	send_message if success
    	end

    	respond_to do |format|
      	format.json {
	        render :json => {:success => success}
      	}
    	end
  end

	def delivered
	end

	private
	    def build_device
	      @device = current_user.devices.find_by_device_uuid(params[:device][:device_uuid])
	      if @device.blank?
	        render :json => {:success => false, :error_code => Request::ERROR_BY_KEY[:device_not_exist]}
	      end
	    end

	    def disallow_requester
	      unless current_user.deliverer
	        render :json => {:success => false, :error_code => Request::ERROR_BY_KEY[:access_denied]}
	      end
	    end	

end
