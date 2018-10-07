class Api::V1::BoardsController < ApplicationController
    before_action :set_board, except: [:index, :create, :show, :user_boards]
    before_action :set_user, only: :user_boards

    def create
        board = current_user.boards.new(board_params)
        if board.save
            render json: board, status: 201
        else
            json_response({errors: board.errors}, '422')
        end
    end

    def destroy
        if @board.update(deleted: true)
            render json: @board, status: 200
        else
            json_response({errors: @board.errors}, '422')
        end
    end

    def update
        if @board.update(board_params)
            render json: @board, status: 200
        else
            json_response({errors: @board.errors}, '422')
        end
    end

    def show
        board = Board.find(params[:id])
        render json: board, status: 200
    end

    def user_boards
        boards = @user.boards
        render json: boards, status: 200
    end


    private
    def board_params
        params.permit(:title, :agenda, :user_id)
    end

    def set_board
        @board = Board.active.find(params[:id])
        # begin
        #     @board = Board.active.find(params[:id])
        # rescue ActiveRecord::RecordNotFound => e
        #     json_response({errors: "The board you are trying to look has been deleted. Could not perform #{action_name} now."}, '400')
        # end
    end

    def set_user
        @user = User.find(params[:id])
    end
end
