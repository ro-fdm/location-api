require 'json'
class GeocodingService

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

  def parse_url
    url = "https://maps.googleapis.com/maps/api/geocode/json?" + "address=#{build_address} " + "&key=#{ENV["api_google_maps"]}"
    URI.escape(url)
  end

  def call_google_maps
    response  = RestClient.get(parse_url)
    errors_control(response)
  end

  def errors_control(response)
    parse_response  = JSON.parse(response)
    if parse_response["status"] == "OK"
      control_partial_match(parse_response)
      get_coordinates(parse_response)
    elsif parse_response["status"] == "ZERO_RESULTS"
      @coordinates[:error] = "address not exist"
    else
      @coordinates[:error] = parse_response["status"]
    end
  end

  def control_partial_match(response)
    if response["results"].first["partial_match"]
      @coordinates[:error] = "possible partial match"
    end
  end

  def get_coordinates(response)
    @coordinates    = {
                       latitude: response["results"].first["geometry"]["location"]["lat"],
                       longitude: response["results"].first["geometry"]["location"]["lng"],
                       formatted_address: response["results"].first["formatted_address"]
                      }
  end

  def add_coordinates
    @location.update_columns(@coordinates)
  end

end