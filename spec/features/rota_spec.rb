require "rails_helper"

feature "Rotas" do
  let(:rota) { build_list(:rota, 5) }

  describe "support rota" do
    before do
      expect(Patterdale::Support::Rota).to receive(:all) { rota }
    end

    scenario "Get a iCal version of the rota" do
      visit "support/rota.ics"

      expect(page.response_headers["Content-Type"]).to match(/text\/calendar/)
    end

    scenario "Get a JSON version of the rota" do
      visit "support/rota.json"

      expect(page.response_headers["Content-Type"]).to match(/application\/json/)
    end
  end

  describe "out of hours rota" do
    before do
      expect(Patterdale::OutOfHours::Rota).to receive(:all) { rota }
    end

    scenario "Get a iCal version of the rota" do
      visit "out-of-hours/rota.ics"

      expect(page.response_headers["Content-Type"]).to match(/text\/calendar/)
    end

    scenario "Get a JSON version of the rota" do
      visit "out-of-hours/rota.json"

      expect(page.response_headers["Content-Type"]).to match(/application\/json/)
    end
  end
end
