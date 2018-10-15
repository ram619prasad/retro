require 'test_helper'

class Api::V1::ColumnsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_token = api_token
    @current_user = current_user(@api_token)
    @user = FactoryBot.create(:user)
    @current_user_board = FactoryBot.create(:board, user_id: @current_user.id)
    @user_board = FactoryBot.create(:board, user_id: @user.id)
    @params = { name: 'New Board', hex_code: '#431990', board_id: @current_user_board.id }

    @current_user_column = FactoryBot.create(:column, board_id: @current_user_board.id, user_id: @current_user.id)
    @user_column = FactoryBot.create(:column, board_id: @user_board.id, user_id: @user.id)
  end
  
  context '#create' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        post api_v1_columns_url, params: @params
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'return error when valid params are not passed' do
        post api_v1_columns_url, params: @params.except(:name), headers: { Authorization: @api_token }
        assert_response :bad_request
        assert json_response.has_key?('errors')
        assert json_response['errors'].has_key?('name')
      end

      should 'create a column when valid params are passed' do
        assert_difference "Column.count", +1 do
          post api_v1_columns_url, params: @params, headers: { Authorization: @api_token }
        end

        assert_response :created
        column_response(json_response)
        column_assertions(json_response['data']['attributes'], Column.last)
      end
    end
  end

  context '#destroy' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        delete api_v1_column_url(@current_user_column.id)
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'delete board succesfully' do
        delete api_v1_column_url(@current_user_column.id), headers: { Authorization: @api_token }
        assert_response :ok

        column = Column.unscoped.where(id: @current_user_column.id).first
        assert column.deleted
      end

      should 'be forbidden when deleting other users boards' do
        delete api_v1_column_url(@user_column.id), headers: { Authorization: @api_token }
        forbidden_assertions
      end
    end
  end

  context '#show' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        get api_v1_column_url(@current_user_column.id)
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'return the column json_response' do
        get api_v1_column_url(@current_user_column.id), headers: { Authorization: @api_token }
        assert_response :ok

        column_response(json_response)
        column_assertions(json_response['data']['attributes'], @current_user_column)
      end

      should 'return not_found when invalid board id is requested' do
        get api_v1_column_url('123456'), headers: { Authorization: @api_token }
        assert_response :not_found
      end
    end
  end

  context '#update' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        patch api_v1_column_url(@current_user_column.id)
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'be able to update' do
        patch api_v1_column_url(@current_user_column.id), params: { name: 'Column Updated' }, headers: { Authorization: @api_token }
        assert_response :success

        column_response(json_response)
        column_assertions(json_response['data']['attributes'], @current_user_column.reload)
      end

      should 'not be able to update other user board columns' do
        patch api_v1_column_url(@user_column.id), params: { name: 'Column Updated' }, headers: { Authorization: @api_token }
        forbidden_assertions
      end

      should 'not update the board when invalid params are passed' do
        patch api_v1_column_url(@current_user_column.id), params: { name: '' }, headers: { Authorization: @api_token }
        assert_response :bad_request
        assert json_response.has_key?('errors')
      end
    end
  end

  private
  def column_response(response)
    assert response.has_key?('data')
    [:id, :type, :attributes, :links].each do |attr|
      assert response['data'].has_key?("#{attr.to_s}"), "#{attr} is not present in data key"
    end
    ['name', 'hex-code', 'deleted'].each do |attr|
      assert response['data']['attributes'].has_key?("#{attr}"), "#{attr} is not present as value in attributes key"
    end
    [:self, :board].each do |attr|
      assert response['data']['links'].has_key?("#{attr.to_s}"), "#{attr} is not present as value in links key"
    end
  end

  def column_assertions(expected, actual)
    assert_equal expected['name'], actual.name
    assert_equal expected['hex-code'], actual.hex_code
    assert_equal expected['deleted'], actual.deleted
  end
end
