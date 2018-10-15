require 'test_helper'

class Api::V1::ActionItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @api_token = api_token
    @current_user = current_user(@api_token)
    @user = FactoryBot.create(:user)

    @current_user_board = FactoryBot.create(:board, user_id: @current_user.id)
    @user_board = FactoryBot.create(:board, user_id: @user.id)

    @current_user_column = FactoryBot.create(:column, board_id: @current_user_board.id, user_id: @current_user.id)
    @user_column = FactoryBot.create(:column, board_id: @user_board.id, user_id: @user.id)

    @current_user_action_item = FactoryBot.create(:action_item, board: @current_user_board, column: @current_user_column, user: @current_user)
    @user_action_item = FactoryBot.create(:action_item, board: @user_board, column: @user_column, user: @user)
    @params = { description: 'Action Item descripton', board_id: @current_user_board.id, column_id: @current_user_column.id }
  end
  
  context '#create' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        post api_v1_action_items_url, params: @params
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'return error when valid params are not passed' do
        post api_v1_action_items_url, params: @params.except(:description), headers: { Authorization: @api_token }
        assert_response :unprocessable_entity
        assert json_response.has_key?('errors')
        assert json_response['errors'].has_key?('description')
      end

      should 'create a column when valid params are passed' do
        assert_difference "ActionItem.count", +1 do
          post api_v1_action_items_url, params: @params, headers: { Authorization: @api_token }
        end

        assert_response :created
        item_response(json_response)
        item_assertions(json_response['data']['attributes'], ActionItem.last)
      end
    end
  end

  context '#destroy' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        delete api_v1_action_item_url(@current_user_action_item.id)
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'delete board succesfully' do
        delete api_v1_action_item_url(@current_user_action_item.id), headers: { Authorization: @api_token }
        assert_response :ok

        column = ActionItem.unscoped.where(id: @current_user_action_item.id).first
        assert column.deleted
      end

      should 'be forbidden when deleting other users boards' do
        delete api_v1_action_item_url(@user_action_item.id), headers: { Authorization: @api_token }
        forbidden_assertions
      end
    end
  end

  context '#update' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        patch api_v1_action_item_url(@current_user_action_item.id)
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'be able to update' do
        patch api_v1_action_item_url(@current_user_action_item.id), params: { description: 'New Description' }, headers: { Authorization: @api_token }
        assert_response :success

        item_response(json_response)
        item_assertions(json_response['data']['attributes'], @current_user_action_item.reload)
      end

      should 'not be able to update other users action items' do
        patch api_v1_action_item_url(@user_action_item.id), params: { description: 'New Description' }, headers: { Authorization: @api_token }
        forbidden_assertions
      end

      should 'not update the action item when invalid params are passed' do
        patch api_v1_action_item_url(@current_user_action_item.id), params: { description: '' }, headers: { Authorization: @api_token }
        assert_response :bad_request
        assert json_response.has_key?('errors')
      end
    end
  end

  private
  def item_response(response)
    assert response.has_key?('data')
    [:id, :type, :attributes, :links].each do |attr|
      assert response['data'].has_key?("#{attr.to_s}"), "#{attr} is not present in data key"
    end
    ['description', 'deleted', 'board-id', 'column-id', 'user-id'].each do |attr|
      assert response['data']['attributes'].has_key?("#{attr}"), "#{attr} is not present as value in attributes key"
    end
    [:self, :board, :column, :user].each do |attr|
      assert response['data']['links'].has_key?("#{attr.to_s}"), "#{attr} is not present as value in links key"
    end
  end

  def item_assertions(expected, actual)
    assert_equal expected['description'], actual.description
    assert_equal expected['deleted'], actual.deleted
    assert_equal expected['board-id'], actual.board_id
    assert_equal expected['column-id'], actual.column_id
    assert_equal expected['user-id'], actual.user_id
  end
end