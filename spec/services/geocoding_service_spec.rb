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
    expect(@location.formatted_address).not_to be_nil

    expect(@location.latitude).to eq(40.3838781)
    expect(@location.longitude).to eq(-3.7030654)
    expect(@location.formatted_address).to eq("Calle Pilarica, 62, 28026 Madrid, Spain")
  end
end