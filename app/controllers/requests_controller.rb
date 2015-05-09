class RequestsController < ApplicationController

  before_action :calculate_distance, :only => :create
  before_action :devices_in_range, :only => :create
  before_action :handle_errors, :only => :create

	def index
	    if current_user.deliverer
	      requests = current_user.to_json(:only => [:first_name, :last_name, :email, :phone_number, :address,
	          :vehicle_number], :include => {:devices => {:include => {:requests => {:include =>
	          [:receiver, :pickup_location, :drop_location]}}}})

	    else
	      requests = current_user.to_json(:only => [:first_name, :last_name, :email, :phone_number, :address,
	          :vehicle_number], :include => {:requests => {:include => [:receiver, :pickup_location,
	          :drop_location]} })
	    end

	    respond_to do |format|
	      format.json {
	        render :json => requests
	      }
	    end	
	end

	def create
		
	    @request = current_user.requests.build( :status => Request::STATUS_BY_KEY[:open],
	                                            :distance => @distance,
	                                            :nearest_deliverers => @nearest_device_ids)
	    @receiver = @request.build_receiver(request_params[:receiver])
	    #@receiver.passcode = rand.to_s[2..7]
	    @receiver.passcode = 1234
	    @pickup_location = @request.create_pickup_location(:lattitude => request_params[:pickup_lattitude], 
	        :longitude => request_params[:pickup_longitude], :address => request_params[:pickup_address])

	    @drop_location = @request.create_drop_location(:lattitude => request_params[:drop_lattitude], 
	      :longitude => request_params[:drop_longitude], :address => request_params[:drop_address])
	    
	    @request.pickup_location_id = @pickup_location.id
	    @request.drop_location_id = @drop_location.id

	    success = @request.save
	    message = {:success => success}
	    
	    if success
	      message[:receiver] = {:name => @receiver.name, :phone_number => @receiver.phone_number,
	                            :order_id => @receiver.order_id }
	      message[:request] = {:id => @request.id, :status => @request.status, :distance => @request.distance}
	      if @request.device and @request.device.user
	        message[:deliverer] = @request.device.user.info
	      end
	    end

	    respond_to do |format|
	      format.json {
	        render :json => message
	      }
	    end
	end

    def destroy
	    Request.destroy_all
	    CurrentLocation.destroy_all
	    EngagedDeliverer.destroy_all
	    Location.destroy_all
	    Receiver.destroy_all
	    # RequesterPayment.destroy_all
	    # DelivererPayment.destroy_all
	    respond_to do |format|
	      format.json {
	        render :json => {:success => true}
	      }
	    end
    end

  def status
    success = false
    message = {}
    id = params[:id]
    request = Request.find_by_id(id)
    receiver = request.receiver

    if request.device and request.device.user
      message[:success] = true
      message[:receiver] = {:name => receiver.name, :phone_number => receiver.phone_number,
                            :order_id => receiver.order_id }
      message[:deliverer] = request.device.user.info
      message[:request] = {:id => request.id, :status => request.status, :distance => request.distance}
    else
      request.destroy
      message[:success] = false
    end

    respond_to do |format|
      format.json {
        render :json => message
      }
    end
  end

	private

	    def request_params
	      	params.require(:request).permit(:pickup_lattitude, :pickup_longitude, :pickup_address,
	          :drop_lattitude, :drop_longitude, :drop_address, :receiver => 
	          [:name, :phone_number, :order_id])
    	end

		def devices_in_range
	      range = 50
	      unassigned_device_locations = 
	          CurrentLocation.where({ :updated_at =>
	              CurrentLocation::TIME_BOUND.seconds.ago.time .. Time.now.utc }).where.not(
	              { :device_id => EngagedDeliverer.all.map(&:device_id) })
	      
	      pickup_location = [request_params[:pickup_lattitude].to_f,request_params[:pickup_longitude].to_f]
	      collected_devices = []
	      unassigned_device_locations.each do |dev|
	        device_distance = calculate_distance_by_haversine(pickup_location,[dev.lattitude,dev.longitude])
	        collected_devices.push({:device_id => dev.device_id,:dist=>device_distance}) unless device_distance > range
	      end
	      sorted_devices = collected_devices.sort_by { |k| k["dist"] }.reverse!.first(10)
	      @nearest_device_ids = sorted_devices.map { |d| d[:device_id] }.join(",")
	    end

	    def calculate_distance
	      loc1 = [request_params[:pickup_lattitude].to_f, request_params[:pickup_longitude].to_f]
	      loc2 = [request_params[:drop_lattitude].to_f, request_params[:drop_longitude].to_f]
	      ## @todo - change this to hit google map api and get distance
	      @distance = calculate_distance_by_haversine(loc1,loc2)
	      @distance = @distance.round(2) # Delta in kilometers
	    end

	    def calculate_distance_by_haversine (loc1,loc2)

	      rad_per_deg = Math::PI/180  # PI / 180
	      rkm = 6371                  # Earth radius in kilometers
	      rm = rkm * 1000             # Radius in meters

	      dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg  # Delta, converted to rad
	      dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

	      lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
	      lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

	      a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
	      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
	      calculated_distance = rkm * c
	      calculated_distance
	    end

	    def handle_errors
	      if current_user.deliverer
	        render :json => {:success => false, :error_code => Request::ERROR_BY_KEY[:access_denied]}
	      elsif @nearest_device_ids.blank?
	        render :json => {:success => false, :error_code => Request::ERROR_BY_KEY[:delieverer_unavailable]}
	      end
	    end	        
end
