class Location < ApplicationRecord
  validates_presence_of :name, :address, :postcode, :city, :country
end
