# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    title { Faker::Lorem.word }
    name { Faker::Name.unique.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
