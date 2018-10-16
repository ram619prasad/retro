# frozen_string_literal: true

# All column related endpoints can be found here.
module Api
  module V1
    # All column related endpoints can be found here.
    class ColumnsController < ApplicationController
      load_resource :board, only: :create
      before_action :authorize_board, only: :create

      load_resource
      authorize_resource except: %i[show create]

      def create
        user_params = { user_id: current_user.id }
        params = column_params.merge!(user_params)
        column = @board.columns.new(params)
        if column.save
          render json: column, status: :created
        else
          json_response({ errors: column.errors }, :bad_request)
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
          json_response({ errors: @column.errors }, :bad_request)
        end
      end

      private

      def authorize_board
        authorize! :update, @board
      end

      def column_params
        params.permit(:name, :hex_code, :board_id, :deleted)
      end
    end
  end
end
