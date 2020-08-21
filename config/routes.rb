# frozen_string_literal: true

Rails.application.routes.draw do
  get "health_check" => "application#health_check"
  root to: "visitors#index"
  scope path: ":type", constraints: {type: %r{out-of-hours|support}} do
    get "rota", to: "rota#show"
  end

  get "/feed.ics", to: redirect("/support/rota.ics")
  get "/local-feed.ics", to: redirect("/support/rota.ics")
end
