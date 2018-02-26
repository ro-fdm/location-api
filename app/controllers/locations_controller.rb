class LocationsController < ApplicationController

  def index
    @locations = Location.all
    json_response(@locations)
  end

  def create
    @location = Location.create!(location_params)
    GeocodingService.new(location: @location).run
    json_response(@location, :created)
  end

  def show
    @location = Location.find(params[:id])
    json_response(@location)
  end

  private

  def location_params
    params.permit(:name, :address, :postcode, :city, :country)
  end
end
