require "spec_helper"

describe Patterdale::OutOfHours::Rota do
  let(:start_date) { Date.parse("2019-01-01") }
  let(:end_date) { Date.parse("2019-02-01") }
  let(:first_line) { build(:user, full_name: "Someone") }
  let(:second_line) { build(:user, full_name: "Someone else") }

  let(:rota) do
    described_class.new(
      start_date: start_date,
      end_date: end_date,
      first_line: first_line,
      second_line: second_line
    )
  end

  describe "#new" do
    it "initializes a rota item" do
      expect(rota.start_date).to eq(start_date)
      expect(rota.end_date).to eq(end_date)
      expect(rota.first_line).to eq(first_line)
      expect(rota.second_line).to eq(second_line)
    end
  end

  describe "#to_h" do
    it "returns the object as a hash" do
      expect(rota.to_h).to eq({
        start_date: start_date,
        end_date: end_date,
        first_line: {
          email: first_line.username,
          name: first_line.full_name
        },
        second_line: {
          email: second_line.username,
          name: second_line.full_name
        }
      })
    end
  end

  describe "all" do
    let(:support_rotations) { double(:support_rotations, upcoming: [rota]) }

    before do
      allow(Patterdale::OutOfHours::Rotations).to receive(:new).and_return(support_rotations)
    end

    it "gets all the rota items" do
      expect(described_class.all.count).to eq(1)
    end
  end
end
