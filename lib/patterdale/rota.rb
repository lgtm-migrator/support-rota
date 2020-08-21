module Patterdale
  class Rota
    def user_detail(user)
      return nil if user.nil?

      {
        name: user.full_name,
        email: user.username
      }
    end

    class << self
      def all
        klass = const_get(name.split("::")[0...-1].join("::"))
        klass::Rotations.new.upcoming
      end
    end
  end
end
