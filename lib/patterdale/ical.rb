module Patterdale
  class ICal
    def initialize(rota)
      @rota = rota
      @cal = Icalendar::Calendar.new
    end

    def results
      add_events
      @cal.publish
      @cal.to_ical
    end

    private

    def add_events
      @rota.each do |rota_item|
        add_event(rota_item)
      end
    end

    def add_event(rota_item)
      @cal.event do |e|
        e.dtstart = Icalendar::Values::Date.new(rota_item.start_date)
        e.dtend = Icalendar::Values::Date.new(rota_item.end_date + 1.day)
        e.summary = rota_item.summary
      end
    end
  end
end
