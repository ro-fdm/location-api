require 'json'
class GeocodingService
  API_KEY="AIzaSyD0BoS9D4bJ8GAJkmNZcDX7WARMj4zZChs"

  def initialize(location:)
    @location = location
    @coordinates = {}
  end

  def run
    call_google_maps
    add_coordinates
  end

  private

  def build_address
    "#{@location.address} #{@location.postcode} #{@location.city} #{@location.country}"
  end

  def call_google_maps
    url       = "https://maps.googleapis.com/maps/api/geocode/json?" + "address=#{build_address} " + "&key=#{API_KEY}"
    parse_url = URI.escape(url)
    response  = RestClient.get(parse_url)
    get_coordinates(response)
  end

  def get_coordinates(response)
    parse_response  = JSON.parse(response)
    @coordinates    = {
                       latitude: parse_response["results"].first["geometry"]["location"]["lat"],
                       longitude: parse_response["results"].first["geometry"]["location"]["lng"],
                       formatted_address: parse_response["results"].first["formatted_address"]
                      }
  end

  def add_coordinates
    @location.update_columns(@coordinates)
  end

end