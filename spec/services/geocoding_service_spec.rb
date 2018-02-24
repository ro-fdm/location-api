require "rails_helper"

RSpec.describe GeocodingService do
  before(:each) do
    @location = FactoryBot.create(:location, name: "Rocio",
                                   address: "Calle Pilarica, ",
                                   postcode: "28026",
                                   city: "Madrid",
                                   country: "Spain")
  end

  it "add latitude and longitude" do
    intercept_googleapis
    
    geocoding = GeocodingService.new(location: @location)
    geocoding.run
    
    expect(@location.latitude).not_to be_nil
    expect(@location.longitude).not_to be_nil
  end
end