require 'test_helper'

class Api::V1::BoardsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @api_token = api_token
    @current_user = current_user(@api_token)
    @user = FactoryBot.create(:user)
    @params = { title: 'New Post', agenda: 'New Agenda' }
    @board = FactoryBot.create(:board, user_id: @current_user.id)
    @user_board = FactoryBot.create(:board, user_id: @user.id)
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

      should 'be forbidden when deleting other users boards' do
        delete api_v1_board_url(@user_board.id), headers: { Authorization: @api_token }
        forbidden_assertions
      end
    end
  end

  context '#update' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        patch api_v1_board_url(@board.id)
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'be able to update only ones board' do
        patch api_v1_board_url(@board.id), params: { title: 'Board Updated' }, headers: { Authorization: @api_token }
        assert_response :success
        
        board_response(json_response)
        board_assertions(json_response['data']['attributes'], @board.reload)
        user_assertions(json_response['data']['attributes']['user'], @current_user)
      end

      should 'not be able to update other user boards' do
        patch api_v1_board_url(@user_board.id), params: { title: 'Board Updated' }, headers: { Authorization: @api_token }
        forbidden_assertions
      end

      should 'not update the board when invalid params are passed' do
        patch api_v1_board_url(@board.id), params: { title: '' }, headers: { Authorization: @api_token }
        assert_response :unprocessable_entity
        assert json_response.has_key?('errors')
      end
    end
  end

  context '#show' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        get api_v1_board_url(@board.id)
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'return the board json_response' do
        get api_v1_board_url(@board.id), headers: { Authorization: @api_token }
        assert_response :ok

        board_response(json_response)
        board_assertions(json_response['data']['attributes'], @board.reload)
        user_assertions(json_response['data']['attributes']['user'], @current_user)
      end

      should 'return not_found when invalid board id is requested' do
        get api_v1_board_url('123456'), headers: { Authorization: @api_token }
        assert_response :not_found
      end
    end
  end

  context '#user_boards' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        get boards_api_v1_user_url(@current_user.id)
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'return the all the boards of the requested user' do
        get boards_api_v1_user_url(@user.id), headers: { Authorization: @api_token }
        assert_response :ok

        board_assertions(json_response['data'][0]['attributes'], @user_board)
        user_assertions(json_response['data'][0]['attributes']['user'], @user)
      end

      should 'return not_found when invalid user id is requested' do
        get boards_api_v1_user_url('0000'), headers: { Authorization: @api_token }
        assert_response :not_found
      end
    end
  end

  context '#my_boards' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        get my_boards_api_v1_boards_url
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'return the all the boards of the current_user' do
        get my_boards_api_v1_boards_url, headers: { Authorization: @api_token }
        assert_response :ok

        board_assertions(json_response['data'][0]['attributes'], @board)
        user_assertions(json_response['data'][0]['attributes']['user'], @current_user)
      end
    end
  end


  context '#index' do
    context 'unauthorized' do
      should 'render unauthorized response' do
        get api_v1_boards_url
        unauthorized_route_assertions
      end
    end

    context 'authorized' do
      should 'return the all the boards and pagination links' do
        get api_v1_boards_url, headers: { Authorization: @api_token }
        assert_response :ok
        assert json_response.has_key?('data')
        assert json_response.has_key?('links')

        pagination_assertions(json_response['links'])
        assert_equal 2, json_response['data'].count
      end

      should 'work with per_page params' do
        get api_v1_boards_url, params: { per_page: 1 }, headers: { Authorization: @api_token }
        assert_response :ok
        assert json_response.has_key?('data')
        assert json_response.has_key?('links')

        pagination_assertions(json_response['links'])
        assert_equal 1, json_response['data'].count

        assert_nil json_response['links']['prev']
        assert_equal query_params(json_response['links']['self'])["page[number]"][0], "1"
        assert_equal query_params(json_response['links']['first'])["page[number]"][0], "1"
        assert_equal query_params(json_response['links']['next'])["page[number]"][0], "2"
        assert_equal query_params(json_response['links']['last'])["page[number]"][0], "2"
      end

      should 'work with page[:number] params' do
        get api_v1_boards_url, params: { per_page: 1, page: { number: 2 } }, headers: { Authorization: @api_token }
        assert_response :ok
        assert json_response.has_key?('data')
        assert json_response.has_key?('links')

        pagination_assertions(json_response['links'])
        assert_equal 1, json_response['data'].count

        assert_nil json_response['links']['next']
        assert_equal query_params(json_response['links']['self'])["page[number]"][0], "2"
        assert_equal query_params(json_response['links']['first'])["page[number]"][0], "1"
        assert_equal query_params(json_response['links']['prev'])["page[number]"][0], "1"
        assert_equal query_params(json_response['links']['last'])["page[number]"][0], "2"

        # puts json_response['links']['self']
        # puts json_response['links']['first']
        # puts json_response['links']['prev']
        # puts json_response['links']['next']
        # puts json_response['links']['last']
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

  def forbidden_assertions
    assert_response :forbidden
    assert json_response.has_key?('message')
    assert_equal 'You are not authorized to perform this action', json_response['message']
  end

  def pagination_assertions(pagination_links)
    [:self, :first, :prev, :next, :last].each do |attr|
      assert pagination_links.has_key?("#{attr.to_s}"), "#{attr} is not present in pagination"
    end
  end

  def query_params(str)
    uri = URI.parse(str)
    CGI.parse(uri.query)
  end
end
