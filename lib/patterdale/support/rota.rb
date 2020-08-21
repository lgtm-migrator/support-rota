module Patterdale
  module Support
    class Rota < ::Patterdale::Rota
      attr_reader :start_date, :end_date, :developer, :ops

      def initialize(start_date:, end_date:, developer:, ops:)
        @start_date = start_date
        @end_date = end_date
        @developer = developer
        @ops = ops
      end

      def developer_name
        developer&.full_name || "Developer TBD"
      end

      def ops_name
        ops&.full_name || "Ops TBD"
      end

      def summary
        "#{developer_name} and #{ops_name} on support"
      end

      def to_h
        {
          start_date: start_date,
          end_date: end_date,
          developer: user_detail(developer),
          ops: user_detail(ops)
        }
      end
    end
  end
end
