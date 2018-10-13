# class Api::V1::ActionItemsController < ApplicationController
#     load_and_authorize_resource :column
#     load_and_authorize_resource through: :column, shallow: false

#     def create
#         byebug
#     end


#     private
#     def action_item_params
#         params.permit(:description, :column_id)
#     end
# end
