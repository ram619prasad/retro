# frozen_string_literal: true

require 'test_helper'

class BoardTest < ActiveSupport::TestCase
  # Associations
  should belong_to(:user)
  should have_many(:columns)

  # Validations
  should validate_presence_of(:title)
  should validate_presence_of(:user_id)
  should validate_uniqueness_of(:title).scoped_to(:user_id)

  # Scopes
  context 'Scopes' do
    setup do
      @active_board = FactoryBot.create(:board)
      @deleted_board = FactoryBot.create(:board, :deleted)
    end

    should 'return active boards for active scope' do
      assert_equal Array(@active_board), Board.active
    end

    should 'return deleted boards for deleted scope' do
      assert_equal Array(@deleted_board), Board.deleted
    end
  end
end
