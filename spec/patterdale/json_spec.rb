require "spec_helper"

describe Patterdale::Json do
  let(:rota) { build_list(:rota, 5) }

  describe "#results" do
    let(:results) { described_class.new(rota).results }

    it "returns the data as JSON" do
      data = JSON.parse(results)

      expect(data.count).to eq(5)
      expect(Date.parse(data.first["start_date"])).to eq(rota.first.start_date)
      expect(Date.parse(data.first["end_date"])).to eq(rota.first.end_date)
      expect(data.first["developer"]).to eq({
        "name" => rota.first.developer.full_name,
        "email" => rota.first.developer.username
      })
      expect(data.first["ops"]).to eq({
        "name" => rota.first.ops.full_name,
        "email" => rota.first.ops.username
      })
    end

    context "when a developer or ops person has not been assigned yet" do
      let(:rota) {
        [
          build(:rota, developer: nil),
          build(:rota, ops: nil)
        ]
      }

      it "returns nil for a user or ops person as appropriate" do
        data = JSON.parse(results)

        expect(data.count).to eq(2)

        expect(data.first["developer"]).to eq(nil)
        expect(data.last["ops"]).to eq(nil)
      end
    end
  end
end
