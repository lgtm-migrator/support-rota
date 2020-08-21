# frozen_string_literal: true

class RotaController < ApplicationController
  def show
    respond_to do |format|
      format.ics { render plain: Patterdale::ICal.new(rota).results, mime_type: Mime::Type.lookup("text/calendar") }
      format.json { render json: Patterdale::Json.new(rota).results }
    end
  end

  private

  def rota
    if params[:type] == "support"
      Patterdale::Support::Rota.all
    else
      Patterdale::OutOfHours::Rota.all
    end
  end
end
