require "rails_helper"

feature "Rotas" do
  before do
    stub_schedule_for_id(ENV.fetch("FIRST_LINE_SCHEDULE_ID"))
    stub_schedule_for_id(ENV.fetch("SECOND_LINE_SCHEDULE_ID"))
    stub_support_rotations(id: ENV.fetch("FIRST_LINE_SCHEDULE_ID"))
    stub_support_rotations(id: ENV.fetch("SECOND_LINE_SCHEDULE_ID"))
    stub_opsgenie_users
  end

  describe "support rota" do
    scenario "Get a JSON version of the rota" do
      visit "/v2/dev/rota.json"

      expect(page.response_headers["Content-Type"]).to match(/application\/json/)
    end
  end
end
