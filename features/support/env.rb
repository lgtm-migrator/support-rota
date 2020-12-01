require "cucumber/rails"
require "cucumber/rspec/doubles"
require "webmock/cucumber"

WebMock.disable_net_connect!(allow_localhost: true)
Capybara.default_host = "http://localhost:3000"

Before do
  stub_opsgenie_schedules
end
