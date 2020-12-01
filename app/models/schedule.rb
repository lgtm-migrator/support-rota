class Schedule
  CONFIGURED_SCHEDULES = [
    ENV.fetch("OPSGENIE_MAIN_SCHEDULE_ID"),
    ENV.fetch("OPSGENIE_OUT_OF_HOURS_2ND_LINE_SCHEDULE_ID")
  ].freeze

  def self.all
    CONFIGURED_SCHEDULES.map do |opsgenie_schedule_id|
      Opsgenie::Schedule.find_by_id(opsgenie_schedule_id)
    end
  end
end
