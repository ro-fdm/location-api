# This file is copied to spec/ when you run 'rails generate rspec:install'
require 'spec_helper'
require 'database_cleaner'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.

require 'webmock/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|

  WebMock.disable_net_connect!(allow_localhost: true)

  def intercept_googleapis
    stub_request(:get, /maps\.googleapis\.com*/).
      to_return(
        status: 200,
        body: body
        )
  end

  def body
    {
    "results": [
        {"address_components": [
          {"long_name": "Puerta del Sol", "short_name": "Puerta del Sol", "types": [ "establishment","park","point_of_interest"]},
          {"long_name": "s/n","short_name": "s/n","types": ["street_number"]},
          {"long_name": "Plaza de la Puerta del Sol","short_name": "Plaza de la Puerta del Sol","types": ["route"]},
          {"long_name": "Madrid","short_name": "Madrid","types": ["locality","political"]},
          {"long_name": "Madrid","short_name": "M","types": ["administrative_area_level_2","political"]},
          {"long_name": "Comunidad de Madrid","short_name": "Comunidad de Madrid","types": ["administrative_area_level_1","political"]},
          {"long_name": "Spain","short_name": "ES","types": ["country","political"]},
          {"long_name": "28013","short_name": "28013","types": ["postal_code"]}
          ],
          "formatted_address": "Puerta del Sol, Plaza de la Puerta del Sol, s/n, 28013 Madrid, Spain",
          "geometry": {"location": {"lat": 40.4169473,"lng": -3.7035285},
                      "location_type": "ROOFTOP",
                      "viewport": {"northeast": {"lat": 40.4182962802915,"lng": -3.702179519708498},
                                   "southwest": {"lat": 40.4155983197085,"lng": -3.704877480291502}
                                  }
                      },
          "place_id": "ChIJXz_iGX4oQg0R-9a-2eSgws4",
          "types": ["establishment","park","point_of_interest"]
        }],
     "status": "OK"
    }.to_json
  end

  def intercept_not_exist
    stub_request(:get, /maps\.googleapis\.com*/).
      to_return(
        status: 200,
        body: {"results": [],
               "status": "ZERO_RESULTS"}.to_json
        )
  end

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type: :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include RequestSpecHelper, type: :request
end
