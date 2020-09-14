module OpsgenieTamer
  class Rota
    attr_reader :date, :role, :person

    def initialize(date:, role:, person:)
      @date = date.to_date
      @role = role
      @person = user_detail(person)
    end

    def ==(other_rota)
      date == other_rota.date &&
        role == other_rota.role &&
        person == other_rota.person
    end

    def to_h
      {
        date: date,
        role: role,
        person: person
      }
    end

    private

    def user_detail(user)
      return nil if user.nil?

      {
        name: user.full_name,
        email: user.username
      }
    end
  end
end
