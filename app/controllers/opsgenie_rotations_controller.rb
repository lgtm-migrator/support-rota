class OpsgenieRotationsController < ApplicationController
  before_action :basic_auth

  def index
    @schedules = Schedule.all
  end

  private

  def basic_auth
    return true if Rails.env == "development"

    realm = "dxw support rota"
    authenticate_or_request_with_http_basic(realm) do |username, password|
      username == ENV.fetch("BASIC_AUTH_USERNAME") &&
        password == ENV.fetch("BASIC_AUTH_PASSWORD")
    end
  end
end
