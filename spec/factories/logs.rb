FactoryBot.define do
  factory :log do
    query { '' }
    answer { 0 }
    created_at { Time.zone.now }

    trait :_1990 do
      query { '1990' }
      answer { '248709873' }
    end
  end
end
