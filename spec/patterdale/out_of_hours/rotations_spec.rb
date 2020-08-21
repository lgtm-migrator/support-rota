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
    it "returns a list of rota items" do
      expect(support_rotations.upcoming.count).to eq(16)
    end
  end
end
