module OpsgenieConfigSH
  def basic_auth(user, password)
    encoded_login = ["#{user}:#{password}"].pack("m*")
    page.driver.header "Authorization", "Basic #{encoded_login}"
  end

  def active_rotations
    active_rotation_ids = %w[
      b073c102-ecd5-4a6f-acf2-443280074c33
      06af48dc-0496-43ea-bae7-77b96e77ff76
      60c5f533-50f9-451a-8c59-61b032838468
      5305436a-0a10-40c6-a677-5fb77bf90b4a
      6fce1fd0-578a-431a-8c18-ae7db8b48bb5
    ]
    Schedule.all
      .map { |schedule| schedule.rotations }
      .flatten
      .select { |rotation| active_rotation_ids.include?(rotation.id) }
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

Then("I see lists of rotations grouped by schedule") do
  Schedule.all.each do |schedule|
    within("#schedule_#{schedule.id}") do
      expect(page).to have_css(".schedule-name", text: schedule.name)
      expect(page).to have_css(".schedule-id", text: schedule.id)

      schedule.rotations.each do |rotation|
        within("#rotation_#{rotation.id}") do
          name = rotation.name.gsub(/\s{2,}/, " ") # ERB is squashing double spaces
          expect(page).to have_css(".rotation-name", text: name)
          expect(page).to have_css(".rotation-id", text: rotation.id)
        end
      end
    end
  end
end

Then("I see each active rotation visually highlighted") do
  active_rotations.each do |rotation|
    expect(page).to have_css("#rotation_#{rotation.id}.active")
  end
end

Given("I'm not authenticated") do
  basic_auth("roger", "rubbish")
end

Then("I see nothing") do
  expect(page.body).to match(/Access denied/)
end
