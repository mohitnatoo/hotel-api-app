module HandleErrors

  extend ActiveSupport::Concern

  included do
    # rescue_from StandardError, with: :handle_api_error
    # rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found
    # rescue_from ValidationError, with: :handle_bad_request
  end

  private

    def handle_bad_request(error)
      respond_with_error error.message, 400
    end
  
    def handle_api_error
      respond_with_error "Something went wrong"
    end

    def handle_record_not_found(error)
      respond_with_error error.message, 404
    end

    def respond_with_error(message, status = 500)
      render json: { error: message }, status: status
    end

end