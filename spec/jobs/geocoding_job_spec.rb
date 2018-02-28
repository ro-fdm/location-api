require 'rails_helper'

RSpec.describe GeocodingJob, type: :job do

  let(:location) {FactoryBot.create(:location,
                                     name: "sol",
                                     address: "Puerta del sol",
                                     city: "Madrid",
                                     country: "Spain") }

  it "check funcionality geocoding job" do
    intercept_googleapis
    GeocodingJob.perform_now(location)
    
    expect(location.latitude).to eq(40.4169473)
    expect(location.longitude).to eq(-3.7035285)
    expect(location.formatted_address).to eq("Puerta del Sol, Plaza de la Puerta del Sol, s/n, 28013 Madrid, Spain")
    expect(location.error).to be_nil
  end
end
