module Patterdale
  class Json
    attr_reader :rota

    def initialize(rota)
      @rota = rota
    end

    def results
      rota.map { |rota_item| rota_item.to_h }.to_json
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
