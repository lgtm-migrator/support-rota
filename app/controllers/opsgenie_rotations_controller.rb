class OpsgenieRotationsController < ApplicationController
  before_action :basic_auth

  ACTIVE_ROTATION_IDS = ENV.fetch("OPSGENIE_IN_HOURS_ROTATION_IDS") +
    ENV.fetch("OPSGENIE_OUT_OF_HOURS_ROTATION_IDS").freeze

  def index
    @schedules = Schedule.all
    @active_rotations = @schedules
      .map { |schedule| schedule.rotations }
      .flatten
      .select { |rotation| ACTIVE_ROTATION_IDS.include?(rotation.id) }
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
