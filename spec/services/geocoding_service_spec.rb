require "rails_helper"

RSpec.describe GeocodingService do
  before(:each) do
    @location = FactoryBot.create(:location, name: "Rocio",
                                   address: "Calle Nuñez de Balboa, 120",
                                   postcode: "28006",
                                   city: "Madrid",
                                   country: "España")
  end


  
  it "add latitude and longitude" do
    geocoding = GeocodingService.new(location: @location)
    geocoding.run
    
    expect(@location.latitude).not_to be_nil
    expect(@location.longitude).not_to be_nil
  end
end