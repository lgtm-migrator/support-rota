module Patterdale
  module OutOfHours
    class Rota < ::Patterdale::Rota
      attr_reader :start_date, :end_date, :first_line, :second_line

      def initialize(start_date:, end_date:, first_line:, second_line:)
        @start_date = start_date
        @end_date = end_date
        @first_line = first_line
        @second_line = second_line
      end

      def first_line_name
        first_line&.full_name || "TBD"
      end

      def second_line_name
        second_line&.full_name || "TBD"
      end

      def summary
        "#{first_line_name} on first line out of hours / #{second_line_name} on second line out of hours"
      end

      def to_h
        {
          start_date: start_date,
          end_date: end_date,
          first_line: user_detail(first_line),
          second_line: user_detail(second_line)
        }
      end
    end
  end
end
