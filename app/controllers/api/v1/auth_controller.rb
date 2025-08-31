# app/controllers/api/v1/auth_controller.rb
class Api::V1::AuthController < Api::V1::ApiController
  before_action :authenticate_user!, except: [:login]

  # POST /api/v1/auth/login
  def login
    user = User.find_by(email: params[:email])
    
    if user&.authenticate(params[:password])
      # For now, just return user data without JWT token
      render_success({
        user: user.as_json(except: [:password_digest]),
        token: "temp_token_#{user.id}" # Placeholder token
      })
    else
      render_error(['Invalid email or password'], :unauthorized)
    end
  end

  # DELETE /api/v1/auth/logout
  def logout
    # For now, just return success (no token invalidation needed yet)
    render_success({ message: 'Logged out successfully' })
  end

  # GET /api/v1/auth/me
  def me
    # Extract user ID from Authorization header for now
    auth_header = request.headers['Authorization']
    if auth_header && auth_header.start_with?('Bearer temp_token_')
      user_id = auth_header.split('temp_token_').last.to_i
      user = User.find_by(id: user_id)
      if user
        render_success(user.as_json(except: [:password_digest]))
      else
        render_error(['User not found'], :not_found)
      end
    else
      render_error(['Authentication required'], :unauthorized)
    end
  end

  private

  def authenticate_user!
    # Placeholder authentication method
    # TODO: Implement proper JWT authentication
    true
  end
end