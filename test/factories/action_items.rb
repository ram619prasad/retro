FactoryBot.define do
  factory :action_item do

    description { Faker::Lorem.sentence(rand(2..10)) }

    before(:create) do |action_item|
      column = FactoryBot.create(:column)
      action_item.user = column.user
      action_item.board = column.board
      action_item.column = column
    end
  end
end
