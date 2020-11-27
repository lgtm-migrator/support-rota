module OpsgenieTamer
  class SupportRotationsFetcher
    HISTORICAL_INTERVAL_IN_MONTHS = 2
    TOTAL_INTERVAL_IN_MONTHS = 12

    def initialize(first_line_schedule_id: ENV.fetch("OPSGENIE_MAIN_SCHEDULE_ID"), second_line_schedule_id: ENV.fetch("OPSGENIE_OUT_OF_HOURS_2ND_LINE_SCHEDULE_ID"))
      @first_line_schedule_id = first_line_schedule_id
      @second_line_schedule_id = second_line_schedule_id
    end

    def call(rotation_type:)
      sorted_periods_for_type(rotation_type).map do |period|
        OpsgenieTamer::Rota.new(
          date: period.start_date,
          role: rotation_type,
          person: period.user
        )
      end
    end

    private

    # attempt to contain the messiness of our OpsGenie schedules and names in one place
    def timeline_name_regex(rotation_type)
      return Regexp.new("Rota") if rotation_type == "ooh2"
      return Regexp.new("ooh", Regexp::IGNORECASE) if rotation_type == "ooh1"

      Regexp.new(rotation_type, Regexp::IGNORECASE)
    end

    def sorted_periods_for_type(rotation_type)
      timelines.select { |t| t.name.match?(timeline_name_regex(rotation_type)) }
        .collect(&:periods)
        .flatten
        .sort_by(&:start_date)
    end

    def timelines
      @timelines ||= schedules.map { |schedule|
        schedule.timeline(
          date: Date.today << HISTORICAL_INTERVAL_IN_MONTHS,
          interval: TOTAL_INTERVAL_IN_MONTHS,
          interval_unit: :months
        )
      }.flatten
    end

    def schedules
      [first_line_schedule, second_line_schedule].compact
    end

    def first_line_schedule
      @first_line_schedule ||= Opsgenie::Schedule.find_by_id(@first_line_schedule_id)
    end

    def second_line_schedule
      @second_line_schedule ||= Opsgenie::Schedule.find_by_id(@second_line_schedule_id)
    end
  end
end
