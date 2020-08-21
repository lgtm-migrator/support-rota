require "rails_helper"

feature "Rotas" do
  after(:each) { Rails.cache.clear }
  before(:each) { Rails.cache.clear }

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

    scenario "it caches the response" do
      visit "/support/rota.json"

      cache = Rails.cache.fetch("/support/rota.json")
      expect(cache.count).to eq(rota.count)
      cache.each do |c|
        expect(c).to be_a(Patterdale::Support::Rota)
      end
    end

    scenario "subsequent requests are cached" do
      visit "/support/rota.json"

      cached_body = page.body

      expect(Patterdale::Support::Rota).to_not receive(:all)

      visit "/support/rota.json"

      expect(page.body).to eq(cached_body)
    end
  end

  describe "out of hours rota" do
    before do
      expect(Patterdale::OutOfHours::Rota).to receive(:all) { rota }.once
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
