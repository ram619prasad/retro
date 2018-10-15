class Api::V1::ColumnsController < ApplicationController
  load_resource :board, only: [:create]
  before_action :authorize_board, only: [:create]

  load_resource
  authorize_resource except: [:show, :create]

  def create
    column = @board.columns.new(column_params.merge!({user_id: current_user.id}))
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
    render json: @column if @column.update_attributes(deleted: true)
  end

  def update
    if @column.update_attributes(column_params)
      render json: @column.reload
    else
      json_response({errors: @column.errors}, :bad_request)
    end
  end

  private
  def authorize_board
    authorize! :update, (@board)
  end

  def column_params
    params.permit(:name, :hex_code, :board_id, :deleted)
  end
end
