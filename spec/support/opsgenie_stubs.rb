module OpsgenieStubs
  def stub_schedule_for_id(id)
    url = "https://api.opsgenie.com/v2/schedules/#{id}?identifierType=id"
    body = JSON.parse(File.read(File.join("spec", "fixtures", "schedule.json"))).to_json
    stub_request(:get, url)
      .to_return(
        status: 200,
        body: body,
        headers: {
          "Content-Type" => "application/json"
        }
      )
  end

  def stub_support_rotations(date: Date.today, id: Patterdale::Support::Rotations::OPSGENIE_SCHEDULE_ID, fixture_name: "support_rotations")
    url = %r{https://api.opsgenie.com/v2/schedules/#{id}/timeline\?date=[0-9:%2BT\-]+&interval=\d+&intervalUnit=months}
    body = JSON.parse(File.read(File.join("spec", "fixtures", "#{fixture_name}.json"))).to_json
    stub_request(:get, url)
      .to_return(
        status: 200,
        body: body,
        headers: {
          "Content-Type" => "application/json"
        }
      )
  end

  def stub_opsgenie_users
    url = "https://api.opsgenie.com/v2/users?limit=500"
    body = JSON.parse(File.read(File.join("spec", "fixtures", "opsgenie_users.json"))).to_json
    stub_request(:get, url)
      .to_return(
        status: 200,
        body: body,
        headers: {
          "Content-Type" => "application/json"
        }
      )
  end
end

RSpec.configure do |config|
  config.include OpsgenieStubs
end
