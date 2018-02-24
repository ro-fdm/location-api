require 'json'
class GeocodingService
  API_KEY="AIzaSyD0BoS9D4bJ8GAJkmNZcDX7WARMj4zZChs"

  def initialize(location:)
    @location = location
  end

  def run
    full_address = build_full_address
    lat, lng = call_google_maps(full_address)
    add_coordinates(lat, lng)
  end

  private

  def build_full_address
    "#{@location.address} #{@location.postcode} #{@location.city} #{@location.country}"
  end

  def call_google_maps(address)
    direction = "https://maps.googleapis.com/maps/api/geocode/json?" + "address=#{address} " + "&key=#{API_KEY}"
    response = RestClient.get(direction)
    lat, lng = parse_response(response)
  end

  def parse_response(response)
    r = JSON.parse(response)
    lat = r["results"].first["geometry"]["location"]["lat"]
    lng = r["results"].first["geometry"]["location"]["lng"]
    return lat, lng
  end

  def add_coordinates(lat, lng)
    @location.update_columns(latitude: lat, longitude: lng)
  end

end