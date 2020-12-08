require "rails_helper"

RSpec.describe "Rota", type: :request do
  before do
    stub_schedule_for_id(ENV.fetch("OPSGENIE_MAIN_SCHEDULE_ID"))
    stub_schedule_for_id(ENV.fetch("OPSGENIE_OUT_OF_HOURS_2ND_LINE_SCHEDULE_ID"))
    stub_support_rotations(id: ENV.fetch("OPSGENIE_MAIN_SCHEDULE_ID"))
    stub_support_rotations(id: ENV.fetch("OPSGENIE_OUT_OF_HOURS_2ND_LINE_SCHEDULE_ID"))
    stub_opsgenie_users
  end

  context "for JSON requests" do
    let(:headers) { json_headers }

    it "returns ok for supported type parameters" do
      %w[dev ooh1 ooh2 ops].each do |type|
        get "/v2/#{type}/rota", headers: headers

        expect(response).to have_http_status(:ok)
      end
    end
  end

  it "returns a routing error for unsupported type parameters" do
    expect { get "/v2/bla/rota", headers: json_headers }.to raise_error(ActionController::RoutingError)
  end

  def json_headers
    {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
  end
end
