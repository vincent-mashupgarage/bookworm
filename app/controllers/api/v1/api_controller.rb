# app/controllers/api/v1/api_controller.rb
class Api::V1::ApiController < ApplicationController
    protect_from_forgery with: :null_session
    
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    
    private
    
    def record_not_found(exception)
      render json: {
        error: 'Record not found',
        message: exception.message
      }, status: :not_found
    end
    
    def record_invalid(exception)
      render json: {
        error: 'Validation failed',
        message: exception.message,
        details: exception.record.errors.full_messages
      }, status: :unprocessable_entity
    end
    
    def render_error(message, status = :bad_request)
      render json: { error: message }, status: status
    end
    
    def render_success(data, status = :ok)
      render json: data, status: status
    end
  end