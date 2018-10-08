require 'test_helper'

class Api::V1::BoardsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @api_token = api_token
    @current_user = current_user(@api_token)
    @params = { title: 'New Post', agenda: 'New Agenda' }
  end
  
  context '#create' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        post api_v1_boards_url, params: @params
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'return error when valid params are not passed' do
        post api_v1_boards_url, params: @params.except(:title), headers: { Authorization: @api_token }
        assert_response :unprocessable_entity
        assert json_response.has_key?('errors')
        assert json_response['errors'].has_key?('title')
      end

      should 'create a board when valid params are passed' do
        assert_difference "Board.count", +1 do
          post api_v1_boards_url, params: @params, headers: { Authorization: @api_token }
        end
        assert_response :created

        board_response(json_response)
        board_assertions(json_response['data']['attributes'], Board.last)
        user_assertions(json_response['data']['attributes']['user'], @current_user)
      end
    end
  end

  context '#destroy' do
    setup do
      @board = FactoryBot.create(:board, user_id: @current_user.id)
    end

    context 'unauthorized' do
      should 'render unauthorized response' do
        delete api_v1_board_url(@board.id)
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'delete board succesfully' do
        delete api_v1_board_url(@board.id), headers: { Authorization: @api_token }
        assert_response :ok

        board = Board.where(id: @board.id).first
        assert board.deleted
      end
    end
  end


  private
  def unauthorized_route_assertions
    assert_response :unauthorized
    assert json_response.has_key?('message')
    assert_equal "Invalid request. No Authorization token present in headers.", json_response['message']
  end

  def board_response(response)
    assert response.has_key?('data')
    [:id, :type, :attributes, :links].each do |attr|
      assert response['data'].has_key?("#{attr.to_s}"), "#{attr} is not present in data key"
    end
    [:title, :agenda, :deleted, :user].each do |attr|
      assert response['data']['attributes'].has_key?("#{attr.to_s}"), "#{attr} is not present as value in attributes key"
    end
    [:id, :name, :email, :title, :boards].each do |attr|
      assert response['data']['attributes']['user'].has_key?("#{attr.to_s}"), "#{attr} is not present as value in user key"
    end
  end

  def board_assertions(expected, actual)
    assert_equal expected['title'], actual.title
    assert_equal expected['agenda'], actual.agenda
    assert_equal expected['deleted'], actual.deleted
  end

  def user_assertions(expected, actual)
    assert_equal expected['id'], actual.id
    assert_equal expected['name'], actual.name
    assert_equal expected['email'], actual.email
    assert_equal expected['title'], actual.title
    assert_equal expected['boards'], actual.boards.count
  end
end
