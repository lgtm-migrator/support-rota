require "spec_helper"

describe Patterdale::Support::Rota do
  let(:start_date) { Date.parse("2019-01-01") }
  let(:end_date) { Date.parse("2019-02-01") }
  let(:developer) { build(:user, full_name: "Someone") }
  let(:ops) { build(:user, full_name: "Someone else") }

  let(:rota) do
    described_class.new(
      start_date: start_date,
      end_date: end_date,
      developer: developer,
      ops: ops
    )
  end

  describe "#new" do
    it "initializes a rota item" do
      expect(rota.start_date).to eq(start_date)
      expect(rota.end_date).to eq(end_date)
      expect(rota.developer).to eq(developer)
      expect(rota.ops).to eq(ops)
    end
  end

  describe "#developer_name" do
    it "returns the developer's name when there is a developer decided for that rotation" do
      expect(rota.developer_name).to eq("Someone")
    end

    it "returns TBD if there is no developer decided for that rotation" do
      rota = described_class.new(start_date: start_date,
                                 end_date: end_date,
                                 developer: nil,
                                 ops: ops)
      expect(rota.developer_name).to eq("Developer TBD")
    end
  end

  describe "#ops_name" do
    it "returns the ops person's name when there is a developer decided for that rotation" do
      expect(rota.ops_name).to eq("Someone else")
    end

    it "returns TBD if there is no ops person decided for that rotation" do
      rota = described_class.new(start_date: start_date,
                                 end_date: end_date,
                                 developer: developer,
                                 ops: nil)
      expect(rota.ops_name).to eq("Ops TBD")
    end
  end

  describe "#to_h" do
    it "returns the object as a hash" do
      expect(rota.to_h).to eq({
        start_date: start_date,
        end_date: end_date,
        developer: {
          email: developer.username,
          name: developer.full_name
        },
        ops: {
          email: ops.username,
          name: ops.full_name
        }
      })
    end
  end

  describe "all" do
    let(:support_rotations) { double(:support_rotations, upcoming: [rota]) }

    before do
      allow(Patterdale::Support::Rotations).to receive(:new).and_return(support_rotations)
    end

    it "gets all the rota items" do
      expect(described_class.all.count).to eq(1)
    end
  end
end
