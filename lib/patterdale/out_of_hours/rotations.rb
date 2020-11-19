module Patterdale
  module OutOfHours
    class UnknownUser
      def username
        "unknown.user@dxw.com"
      end

      def full_name
        "Unknown User"
      end
    end

    class Rotations
      FIRST_LINE_SCHEDULE_ID = "e71d500f-896a-4b28-8b08-3bfe56e1ed76"
      SECOND_LINE_SCHEDULE_ID = "b8e97704-0e9d-41b5-b27c-9d9027c83943"

      UNKNOWN_USER = UnknownUser.new.freeze

      def initialize(ooh_rotation_ids: ENV.fetch("ROTATION_IDS"))
        @ooh_rotation_ids = ooh_rotation_ids.split(",")
      end

      def upcoming
        chunked_schedule.map do |support_batch|
          start_date = support_batch.first[:date]
          end_date = support_batch.last[:date]
          first_line = support_batch.first[:first_line]
          second_line = support_batch.first[:second_line]

          Rota.new(
            start_date: start_date,
            end_date: end_date,
            first_line: first_line,
            second_line: second_line
          )
        end
      end

      private

      # Group support days into batches with the same combined team
      # so the start date and end date is a continuous block of time
      def chunked_schedule
        daily_schedule.chunk_while do |before, after|
          after[:first_line] == before[:first_line] &&
            after[:second_line] == before[:second_line] &&
            after[:date] - before[:date] <= 1
        end
      end

      def daily_schedule
        # Fetch the total timespan of the support periods that we have
        start_date = (first_line_periods + second_line_periods).min_by(&:start_date).start_date.to_date
        end_date = (first_line_periods + second_line_periods).max_by(&:end_date).end_date.to_date
        # Cycle through all these days and check who is on call for each of these days
        (start_date..end_date).map do |date|
          first_line_on_call = find_user_for_date(first_line_periods, date)
          second_line_on_call = find_user_for_date(second_line_periods, date)
          {
            date: date,
            first_line: first_line_on_call,
            second_line: second_line_on_call
          }
        end
      end

      def first_line_schedule
        @first_line_schedule ||= Opsgenie::Schedule.find_by_id(FIRST_LINE_SCHEDULE_ID)
      end

      def second_line_schedule
        @second_line_schedule ||= Opsgenie::Schedule.find_by_id(SECOND_LINE_SCHEDULE_ID)
      end

      def first_line_periods
        @first_line_periods ||= get_periods_for_schedule(first_line_schedule)
      end

      def second_line_periods
        @second_line_periods ||= get_periods_for_schedule(second_line_schedule)
      end

      def get_periods_for_schedule(schedule)
        schedule.timeline(interval: 3, interval_unit: :months).select { |t| @ooh_rotation_ids.include?(t.id) }.map { |r| r.periods }.flatten
      end

      def find_user_for_date(periods, date)
        period =
          periods.find { |p|
            (p.start_date.to_date..p.end_date.to_date).cover?(date)
          }

        period&.user || UNKNOWN_USER
      end
    end
  end
end
