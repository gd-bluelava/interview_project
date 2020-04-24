FactoryBot.define do
  factory :population do
    year { 0 }
    population { 0 }

    trait :invalid_negatives do
      year { -1 }
      population { -1 }
    end

    trait :invalid_floats do
      year { 1.23 }
      population { 4.56 }
    end

    trait :_1900 do
      year { 1900 }
      population { 76_212_168 }
    end

    trait :_1902 do
      year { 1902 }
      population { 76_212_168 }
    end

    trait :_1990 do
      year { 1990 }
      population { 248_709_873 }
    end

    trait :_1991 do
      year { 1991 }
    end

    trait :_2000 do
      year { 2000 }
      population { 248_709_873 }
    end
  end
end
