class Api::V1::ColumnsController < ApplicationController
    before_action :find_active_board, only: [:create]
    before_action :find_users_active_board, only: :update

    load_resource
    authorize_resource except: [:show]

    def create
        column = @board.columns.new(column_params)
        if column.save
            render json: column, status: :created
        else
            json_response({errors: column.errors}, :bad_request)
        end
    end

    def show
        render json: @column
    end

    def destroy
        render json: @column if @column.update(deleted: true)
    end

    def update
        if @column.update_attributes(column_params)
            render json: @column.reload
        else
            json_response({errors: @column.errors}, :bad_request)
        end
    end


    private
    def column_params
        params.permit(:name, :hex_code, :board_id, :deleted)
    end

    def find_active_board
        @board = Board.active.find(params[:board_id])
    end

    def find_users_active_board
        @board = @current_user.boards.active.find(params[:board_id])
    end
end
