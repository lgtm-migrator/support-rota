# frozen_string_literal: true

Rails.application.routes.draw do
  get "health_check" => "application#health_check"
  root to: "application#health_check"
  scope path: ":type", constraints: {type: %r{out-of-hours|support}} do
    get "rota", to: "rota#show"
  end

  get "/feed.ics", to: redirect("/support/rota.ics")
  get "/local-feed.ics", to: redirect("/support/rota.ics")

  namespace :v2 do
    scope path: ":type", constraints: {type: %r{dev|ops|ooh1|ooh2}} do
      get "rota", to: "rota#show"
    end
  end
end
