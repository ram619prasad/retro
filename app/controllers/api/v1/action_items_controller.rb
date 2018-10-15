class Api::V1::ActionItemsController < ApplicationController
    load_resource :column, only: [:create, :update]
    load_and_authorize_resource

    def create
       params = action_item_params.merge!({ user_id: current_user.id, board_id: @column.board_id })
       action_item = @column.action_items.new(params)

       if action_item.save
            render json: action_item, status: :created
       else
            json_response({errors: action_item.errors}, :unprocessable_entity)
       end
    end

    def update
        params = action_item_params.except(:column_id)

        if @action_item.update_attributes(params)
            render json: @action_item, status: :created
       else
            json_response({errors: @action_item.errors}, :bad_request)
       end
    end

    def destroy
        render json: @action_item if @action_item.update_attributes(deleted: true)
    end

    private
    def action_item_params
        params.permit(:description, :column_id, :deleted)
    end
end
