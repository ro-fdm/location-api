require "rails_helper"

RSpec.describe GeocodingService do

  let(:location) {FactoryBot.create(:location,
                                     name: "Rocio",
                                     address: "Calle Pilarica, 6",
                                     city: "Madrid",
                                     country: "Spain") }
  let (:location_invent) { FactoryBot.create(:location,
                                      name: "Inventada",
                                      address: "Calle Piruleta, 42",
                                      city: "Esmeralda",
                                      country: "Oz") }

  it "add coordinates" do
    intercept_googleapis

    expect(location.latitude).to be_nil
    expect(location.longitude).to be_nil
    expect(location.formatted_address).to be_nil

    geocoding = GeocodingService.new(location: location)
    geocoding.run
    
    expect(location.latitude).to eq(40.3838781)
    expect(location.longitude).to eq(-3.7030654)
    expect(location.formatted_address).to eq("Calle Pilarica, 62, 28026 Madrid, Spain")
    expect(location.error).to be_nil
  end

  it "not exist" do
    intercept_not_exist
    geocoding = GeocodingService.new(location: location_invent)
    geocoding.run
    
    expect(location_invent.latitude).to be_nil
    expect(location_invent.longitude).to be_nil
    expect(location_invent.formatted_address).to be_nil
    expect(location_invent.error).not_to be_nil
    expect(location_invent.error).to eq("address not exist")
  end
end