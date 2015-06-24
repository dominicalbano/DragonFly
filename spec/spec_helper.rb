# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'capybara'
require 'cucumber'
require 'watir-webdriver'
require 'net/http'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
## comment this out because we don't have any files to run in spec/ directory
# Dir[Rails.root.join("spec/requests/**/*.rb")].each { |f| require f }



RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  ####config.order = "random"

  # Load FactoryGirl helpers
  config.include FactoryGirl::Syntax::Methods
end

# Explicitly set the test server process to a particular port
# so that we can access it directly at will.
Capybara.server_port = 10000

# To ensure that browser tests can find the test server process,
# always include the port number in URLs.
Capybara.always_include_port = true

# For all tests except Javascript tests we will use :rack_test
# (the default) as it is the fastest. For Javascript tests we will
# use Selenium as it is the most robust/mature browser driver
# available.
Capybara.javascript_driver = :selenium