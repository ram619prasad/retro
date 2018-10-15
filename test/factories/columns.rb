FactoryBot.define do
  factory :column do
    user
    board

    name { Faker::Lorem.word }
    hex_code { "#431990" }

    trait :deleted do
      deleted { true }
    end
  end
end
