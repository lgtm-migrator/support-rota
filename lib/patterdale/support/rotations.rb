module Patterdale
  module Support
    class Rotations
      OPSGENIE_SCHEDULE_ID = "e71d500f-896a-4b28-8b08-3bfe56e1ed76"

      def initialize(in_hours_rotation_ids: ENV.fetch("OPSGENIE_IN_HOURS_ROTATION_IDS"), opsgenie_schedule_id: ENV.fetch("OPSGENIE_MAIN_SCHEDULE_ID"))
        @in_hours_rotation_ids = in_hours_rotation_ids.split(",")
        @opsgenie_schedule_id = opsgenie_schedule_id
      end

      def self.create_rota_item(support_batch)
        return unless support_batch.first && support_batch.last

        start_date = support_batch.first.day
        developer = support_batch.first.developer
        ops = support_batch.first.ops_eng
        end_date = support_batch.last.day

        Rota.new(
          start_date: start_date,
          end_date: end_date,
          developer: developer,
          ops: ops
        )
      end

      def upcoming
        single_discipline_days = single_discipline_support_days(devops_timelines)
        combined_days = team_support_days(single_discipline_days)
        batched_days = batched_team_support_days(combined_days)
        batched_days.map { |batch| Patterdale::Support::Rotations.create_rota_item(batch) }.compact
      end

      def single_discipline_support_days(timelines)
        timelines.map { |timeline|
          timeline.periods.map do |period|
            DisciplineSupportDay.new(period: period, timeline: timeline)
          end
        }.flatten
      end

      def team_support_days(support_days)
        support_days
          .group_by(&:day)
          .map do |calendar_day, supp_days|
            TeamSupportDay.new(day: calendar_day, support_days: supp_days)
          end
      end

      # Groups support days into batches with the same combined devops team
      # so the start date and end date is a continuous block of time
      def batched_team_support_days(single_days)
        single_days.chunk_while do |before, after|
          after.developer == before.developer &&
            after.ops_eng == before.ops_eng &&
            after.day - before.day <= 1
        end
      end

      def devops_timelines
        timelines.select { |t| @in_hours_rotation_ids.include?(t.id) }
      end

      private

      def schedule
        @schedule ||= Opsgenie::Schedule.find_by_id(@opsgenie_schedule_id)
      end

      def timelines
        @timelines ||= schedule.timeline(interval: 3, interval_unit: :months)
      end

      DisciplineSupportDay = Struct.new(:period, :timeline, keyword_init: true) {
        def day
          period.start_date.to_date
        end

        def discipline
          return "ops" if /ops/i.match?(timeline.name)
          return "developer" if /dev/i.match?(timeline.name)

          timeline.name
        end

        def person
          period.user
        end
      }

      TeamSupportDay = Struct.new(:day, :support_days, keyword_init: true) {
        def developer
          extract_person_by_discipline(support_days, "developer")
        end

        def ops_eng
          extract_person_by_discipline(support_days, "ops")
        end

        private

        def extract_person_by_discipline(periods, discipline)
          periods.find { |p| p.discipline == discipline }&.person
        end
      }
    end
  end
end
