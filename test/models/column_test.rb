# frozen_string_literal: true

require 'test_helper'

class ColumnTest < ActiveSupport::TestCase
  should belong_to(:board)

  should validate_presence_of(:name)
  should validate_presence_of(:hex_code)

  context 'hex_code length validation' do
    setup do
      @board = FactoryBot.create(:board)
    end

    should 'not accept if hex_code length is either 4 or 7' do
      column = Column.create(name: 'some title', hex_code: '#s123',
                             board_id: @board.id)
      assert_equal 'Invalid hexcode',
                   column.errors.details[:hex_code][0][:error]
    end
  end
end
