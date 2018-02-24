require 'rails_helper'

RSpec.describe Location, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:postcode) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:country) }
end
