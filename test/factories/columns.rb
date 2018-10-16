# frozen_string_literal: true

FactoryBot.define do
  factory :column do
    name { Faker::Lorem.word }
    hex_code { '#431990' }

    # before(:create) do |col|
    #   board = FactoryBot.create(:board)
    #   col.user = board.user
    #   col.board = board
    # end

    trait :deleted do
      deleted { true }
    end
  end
end
