require "spec_helper"

RSpec.describe Patterdale::OutOfHours::Rotations do
  let(:support_rotations) { described_class.new }

  before do
    Timecop.travel("2020-02-01")
    stub_opsgenie_users
    stub_schedule_for_id(described_class::FIRST_LINE_SCHEDULE_ID)
    stub_schedule_for_id(described_class::SECOND_LINE_SCHEDULE_ID)
    stub_support_rotations(date: Date.today, id: described_class::FIRST_LINE_SCHEDULE_ID, fixture_name: "first_line_ooh_rotations")
    stub_support_rotations(date: Date.today, id: described_class::SECOND_LINE_SCHEDULE_ID, fixture_name: "second_line_ooh_rotations")
  end

  after do
    Timecop.return
  end

  describe "upcoming" do
    let(:first_line_names) do
      support_rotations
        .upcoming
        .map { |rota| rota.first_line.full_name }
        .uniq
    end

    let(:second_line_names) do
      support_rotations
        .upcoming
        .map { |rota| rota.second_line.full_name }
        .uniq
    end

    it "inserts UnknownUser null object into gaps in the rotas" do
      aggregate_failures do
        expect(first_line_names).to eq(
          [
            "Unknown User",
            "Chuck",
            "Alice",
            "Craig",
            "Dan",
            "Carol",
            "Dave",
            "Carlos",
            "Erin",
            "Eve",
            "Charlie",
            "bob example"
          ]
        )
        expect(second_line_names).to eq(
          [
            "Alice",
            "Carol",
            "bob example",
            "Charlie",
            "Unknown User"
          ]
        )
      end
    end

    it "returns a list of rota items" do
      expect(support_rotations.upcoming.count).to eq(31)
    end
  end
end
