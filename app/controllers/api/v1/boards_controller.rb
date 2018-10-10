class Api::V1::BoardsController < ApplicationController
    load_resource only: :show
    load_and_authorize_resource only: [:update, :destroy]
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
        render json: @board if @board.update(deleted: true)
    end

    def update
        authorize! :update, @board

        if @board.update_attributes(board_params)
            render json: @board
        else
            json_response({errors: @board.errors}, '422')
        end
    end

    def show
        render json: @board
    end

    def user_boards
        boards = @user.boards
        render json: boards
    end

    def my_boards
        boards = @current_user.boards
        render json: boards
    end

    def index
        page = params[:page].try(:[], :number) || 1
        per = params[:per_page]
        @boards = Board.page(page).per(per)
        render json: @boards
    end


    private
    def board_params
        params.permit(:title, :agenda, :user_id)
    end

    def set_user
        @user = User.find(params[:id])
    end
end
