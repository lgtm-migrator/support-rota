module OpsgenieConfigSH
  def basic_auth(user, password)
    encoded_login = ["#{user}:#{password}"].pack("m*")
    page.driver.header 'Authorization', "Basic #{encoded_login}"
  end
end

World OpsgenieConfigSH

Given("I am authenticated as an admin") do
  basic_auth(
    ENV.fetch("BASIC_AUTH_USERNAME"),
    ENV.fetch("BASIC_AUTH_PASSWORD")
  )
end

When("I visit the opsgenie config page") do
  visit "/opsgenie_rotations"
end

Then('I see lists of rotations grouped by schedule') do
  Schedule.all.each do |schedule|
    within("#schedule_#{schedule.id}") do
      expect(page).to have_css('.schedule-name', text: schedule.name)
      expect(page).to have_css('.schedule-id', text: schedule.id)
    end
  end
end

Then('I see each active rotation visually highlighted') do
  pending # Write code here that turns the phrase above into concrete actions
end

Given("I'm not authenticated") do
  basic_auth("roger", "rubbish")
end

Then("I see nothing") do
  expect(page.body).to match(/Access denied/)
end
