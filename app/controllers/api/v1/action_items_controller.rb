# frozen_string_literal: true

# All action item endpoints can be found here.
module Api
  module V1
    # All action item endpoints can be found here.
    class ActionItemsController < ApplicationController
      load_resource :column, only: %i[create update]
      load_and_authorize_resource

      def create
        assoc_params = { user_id: current_user.id, board_id: @column.board_id }
        params = action_item_params.merge!(assoc_params)
        action_item = @column.action_items.new(params)

        if action_item.save
          render json: action_item, status: :created
        else
          json_response({ errors: action_item.errors }, :unprocessable_entity)
        end
      end

      def update
        params = action_item_params.except(:column_id)

        if @action_item.update_attributes(params)
          render json: @action_item, status: :created
        else
          json_response({ errors: @action_item.errors }, :bad_request)
        end
      end

      def destroy
        params = { deleted: true }
        render json: @action_item if @action_item.update_attributes(deleted: true)
      end

      private

      def action_item_params
        params.permit(:description, :column_id, :deleted)
      end
    end
  end
end
