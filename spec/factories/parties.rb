FactoryBot.define do
  factory :mock_party, class: Party do
    movie_id { nil }
    duration { Faker::Number.between(from: 0.0, to: 100.0) }
    start_time { "3:00 PM"}
    date { "06/07/2021" }
    host_id { nil } 
  end
end
