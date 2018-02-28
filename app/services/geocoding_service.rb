require 'json'
class GeocodingService

  def initialize(location:)
    @location = location
  end

  def run
    @location.update!(get_coordinates)
  end

  private

  def get_coordinates
    response  = RestClient.get(parse_url)

    handle_response(response)
  end

  def parse_url
    url = "https://maps.googleapis.com/maps/api/geocode/json?" +
          "address=#{build_address} " + 
          "&key=#{ENV["api_google_maps"]}"
    URI.escape(url)
  end

  def build_address
    "#{@location.address} #{@location.postcode} #{@location.city} #{@location.country}"
  end

  def handle_response(response)
    parse_response = JSON.parse(response)
    first_result   = parse_response["results"].first
    if parse_response["status"] == "OK"
      coordinates(first_result).merge( control_partial_match(first_result) )
    else
      { error: parse_response["status"],
        status: "ERROR" }
    end
  end

  def control_partial_match(result)
    if result["partial_match"]
      { error: "possible partial match"}
    else
      {}
    end
  end

  def coordinates(result)
    { latitude:          result.dig("geometry", "location", "lat"),
      longitude:         result.dig("geometry", "location", "lng"),
      formatted_address: result["formatted_address"],
      status: "OK" }
  end
end