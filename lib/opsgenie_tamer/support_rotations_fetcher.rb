module OpsgenieTamer
  class SupportRotationsFetcher
    FIRST_LINE_SCHEDULE_ID = "e71d500f-896a-4b28-8b08-3bfe56e1ed76"
    SECOND_LINE_SCHEDULE_ID = "b8e97704-0e9d-41b5-b27c-9d9027c83943"
    HISTORICAL_INTERVAL_IN_MONTHS = 2
    TOTAL_INTERVAL_IN_MONTHS = 12

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
      @first_line_schedule ||= Opsgenie::Schedule.find_by_id(FIRST_LINE_SCHEDULE_ID)
    end

    def second_line_schedule
      @second_line_schedule ||= Opsgenie::Schedule.find_by_id(SECOND_LINE_SCHEDULE_ID)
    end
  end
end
