class CurrentLocationsController < ApplicationController

  def update_location
    success = false
    device_uuid = params[:current_location][:device] && params[:current_location][:device][:device_uuid]

    if device_uuid and current_user and current_user.deliverer
      device = current_user.devices.find_by_device_uuid(device_uuid)
      success = device.build_current_location(current_location_params).save if device
    end
    respond_to do |format|
      format.json {
        render :json => {:success => success}
      }
    end
  end

  private

  def current_location_params
    params.require(:current_location).permit(:lattitude, :longitude)
  end

end