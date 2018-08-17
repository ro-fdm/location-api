require "rails_helper"

RSpec.describe GeocodingService do

  let(:location) {FactoryBot.create(:location,
                                     name: "sol",
                                     address: "Puerta del sol",
                                     city: "Madrid",
                                     country: "Spain") }
  let (:location_invent) { FactoryBot.create(:location,
                                      name: "Inventada",
                                      address: "Calle Piruleta, 42",
                                      city: "Esmeralda",
                                      country: "Oz") }

  it "add coordinates" do
    intercept_exist

    expect(location.latitude).to be_nil
    expect(location.longitude).to be_nil
    expect(location.formatted_address).to be_nil

    geocoding = GeocodingService.new(location: location)
    geocoding.run
    
    expect(location.latitude).to eq(40.4169473)
    expect(location.longitude).to eq(-3.7035285)
    expect(location.formatted_address).to eq("Puerta del Sol, Plaza de la Puerta del Sol, s/n, 28013 Madrid, Spain")
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
    expect(location_invent.error).to eq("ZERO_RESULTS")
  end

  it "select best result" do
    intercept_various_result
    geocoding = GeocodingService.new(location: location)
    geocoding.run

    expect(location.latitude).to eq(12.3456789)
    expect(location.longitude).to eq(0.1234568)
    expect(location.formatted_address).to eq("result number two")
  end
end