RSpec.describe OpsgenieTamer::SupportRotationsFetcher do
  before do
    stub_schedule_for_id(ENV.fetch("OPSGENIE_MAIN_SCHEDULE_ID"))
    stub_schedule_for_id(ENV.fetch("OPSGENIE_OUT_OF_HOURS_2ND_LINE_SCHEDULE_ID"))
    stub_support_rotations(id: ENV.fetch("OPSGENIE_MAIN_SCHEDULE_ID"))
    stub_support_rotations(id: ENV.fetch("OPSGENIE_OUT_OF_HOURS_2ND_LINE_SCHEDULE_ID"))
    stub_opsgenie_users
  end

  describe "#call" do
    let(:fetcher) { OpsgenieTamer::SupportRotationsFetcher.new }
    let(:user) { build(:user, full_name: "Alice", username: "alice@example.com") }
    let(:rota) { OpsgenieTamer::Rota.new(date: Date.new(2020, 2, 5), role: "dev", person: user) }

    it "returns an array of rotas sorted by date" do
      rotas = fetcher.call(rotation_type: "dev")

      expect(rotas.first).to eq(rota)
    end
  end
end
