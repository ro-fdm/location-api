class GeocodingJob < ApplicationJob
  queue_as :default

  def perform(location)
    GeocodingService.new(location: location).run

  rescue => e
    location.update_columns(error: e.message)
  end
end
