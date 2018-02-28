class GeocodingJob < ApplicationJob
  queue_as :default

  def perform(location)
    GeocodingService.new(location: location).run

  rescue => error
    location.update_columns(error: error)
  end
end
