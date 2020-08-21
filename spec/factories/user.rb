FactoryBot.define do
  factory :user, class: Opsgenie::User do
    id { SecureRandom.uuid }
    full_name { "User" }
    username { "user@example.com" }

    initialize_with { new("id" => id, "fullName" => full_name, "username" => username) }
  end
end
