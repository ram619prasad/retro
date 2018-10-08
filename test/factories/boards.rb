FactoryBot.define do
  factory :board do
    user
    title { Faker::Lorem.word }
    agenda { Faker::Lorem.sentence(rand(2..10)) }

    trait :deleted do
      deleted { true }
    end
  end
end
