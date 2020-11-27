require "spec_helper"

RSpec.describe Patterdale::Support::Rotations do
  let(:support_rotations) { described_class.new }

  before do
    Timecop.travel("2020-02-01")
    stub_schedule_for_id(ENV.fetch("OPSGENIE_MAIN_SCHEDULE_ID"))
    stub_support_rotations(id: ENV.fetch("OPSGENIE_MAIN_SCHEDULE_ID"))
    stub_opsgenie_users
  end

  after do
    Timecop.return
  end

  describe ".create_rota_item" do
    let(:alice) { build(:user, full_name: "Alice", username: "alice@example.com") }
    let(:bob) { build(:user, full_name: "bob example", username: "bob@example.com") }
    let(:batch) do
      [
        double(:team_day, day: Date.new(2020, 1, 1), developer: alice, ops_eng: bob),
        double(:team_day, day: Date.new(2020, 1, 2), developer: alice, ops_eng: bob),
        double(:team_day, day: Date.new(2020, 1, 3), developer: alice, ops_eng: bob)
      ]
    end

    it "creates a valid Rota item" do
      rota_item = described_class.create_rota_item(batch)

      expect(rota_item.start_date).to eq(Date.parse("2020-01-01"))
      expect(rota_item.end_date).to eq(Date.parse("2020-01-03"))
      expect(rota_item.developer).to eq(alice)
      expect(rota_item.ops).to eq(bob)
    end
  end

  describe "#upcoming" do
    context "when the days are separated by weekends" do
      it "creates a rota item for each contiguous group of days" do
        expect(support_rotations.upcoming.size).to eq(3)
      end
    end

    context "when a day has been split into 2 timeline periods" do
      it "creates a single rota item" do
        stub_support_rotations(fixture_name: "support_rotations_today")

        expect(support_rotations.upcoming.size).to eq(1)
      end
    end
  end

  describe "#devops_timelines" do
    it "includes only dev and ops timelines" do
      expect(support_rotations.devops_timelines.map(&:name)).to match_array(["Ops", "Dev"])
    end
  end

  describe "#single_discipline_support_days" do
    it "returns a flat array of DisciplineSupportDays" do
      timelines = support_rotations.devops_timelines
      single_days = support_rotations.single_discipline_support_days(timelines)

      expect(single_days.size).to eq(11)

      expect(single_days.first.day).to eq(Date.parse("2020-01-01"))
      expect(single_days.first.discipline).to eq("ops")
      expect(single_days.first.person.full_name).to eq("bob example")

      expect(single_days.last.day).to eq(Date.parse("2020-02-11"))
      expect(single_days.last.discipline).to eq("developer")
      expect(single_days.last.person.full_name).to eq("Alice")
    end
  end

  describe "#team_support_days" do
    it "returns an array of TeamSupportDays" do
      single_days = [
        double(:single_day, day: Date.new(2020, 1, 1), discipline: "ops", person: double(:person, full_name: "bob example")),
        double(:single_day, day: Date.new(2020, 1, 1), discipline: "developer", person: double(:person, full_name: "Alice")),
        double(:single_day, day: Date.new(2020, 1, 2), discipline: "ops", person: double(:person, full_name: "bob example"))
      ]

      team_days = support_rotations.team_support_days(single_days)

      expect(team_days.size).to eq(2)

      expect(team_days[0].day).to eq(Date.parse("2020-01-01"))
      expect(team_days[0].developer.full_name).to eq("Alice")
      expect(team_days[0].ops_eng.full_name).to eq("bob example")

      expect(team_days[1].day).to eq(Date.parse("2020-01-02"))
      expect(team_days[1].developer).to eq(nil)
      expect(team_days[1].ops_eng.full_name).to eq("bob example")
    end
  end

  describe "#batched_team_support_days" do
    let(:alice) { double(:person, full_name: "Alice") }
    let(:bob) { double(:person, full_name: "bob example") }
    let(:noone) { double(:person, full_name: "dev TBD") }
    let(:team_support_days) do
      [
        double(:team_day, day: Date.new(2020, 1, 1), developer: alice, ops_eng: bob),
        double(:team_day, day: Date.new(2020, 1, 2), developer: alice, ops_eng: bob),
        double(:team_day, day: Date.new(2020, 1, 3), developer: noone, ops_eng: bob)
      ]
    end

    it "returns an enumerator of batches of team support days" do
      batched_days = support_rotations.batched_team_support_days(team_support_days)

      expect(batched_days.count).to eq(2)

      first_batch = batched_days.first

      expect(first_batch.first.day).to eq(Date.new(2020, 1, 1))
      expect(first_batch.first.developer.full_name).to eq("Alice")
      expect(first_batch.first.ops_eng.full_name).to eq("bob example")

      expect(first_batch.last.day).to eq(Date.new(2020, 1, 2))
      expect(first_batch.last.developer.full_name).to eq("Alice")
      expect(first_batch.last.ops_eng.full_name).to eq("bob example")
    end
  end
end
