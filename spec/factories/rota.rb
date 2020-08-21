FactoryBot.define do
  factory :rota, class: Patterdale::Support::Rota do
    sequence(:start_date) { |n| Date.today + (6 * n).days }
    end_date { start_date + 6.days }
    sequence(:developer) { |n| build(:user, full_name: "Developer #{n}", username: "developer#{n}@example.com") }
    sequence(:ops) { |n| build(:user, full_name: "Ops #{n}", username: "ops#{n}@example.com") }

    initialize_with { new(attributes) }
  end
end
