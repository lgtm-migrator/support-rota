# frozen_string_literal: true

class V2::RotaController < ApplicationController
  def show
    respond_to do |format|
      format.json { render json: Patterdale::Json.new(rota).results }
    end
  end

  private

  def rota
    Rails.cache.fetch request.path, expires_in: 12.hours do
      OpsgenieTamer::SupportRotationsFetcher.new.call(rotation_type: params[:type])
    end
  end
end
