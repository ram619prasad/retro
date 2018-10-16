# frozen_string_literal: true

# Just a helper method for handling the json response.
module Response
  def json_response(object, status = :ok)
    render json: object, status: status
  end
end
