# app/controllers/api/v1/users_controller.rb
class Api::V1::UsersController < Api::V1::ApiController
    before_action :set_user, only: [:show, :update, :destroy]
    # Add authentication later: before_action :authenticate_user!, except: [:create]
    
    # GET /api/v1/users (admin only)
    def index
      @users = User.all
      render_success(@users.as_json(except: [:password_digest]))
    end
    
    # GET /api/v1/users/:id
    def show
      render_success(@user.as_json(except: [:password_digest]))
    end
    
    # POST /api/v1/users (registration)
    def create
      @user = User.new(user_params)
      
      if @user.save
        render_success(
          @user.as_json(except: [:password_digest]),
          :created
        )
      else
        render_error(@user.errors.full_messages, :unprocessable_entity)
      end
    end
    
    # PUT/PATCH /api/v1/users/:id
    def update
      if @user.update(user_params)
        render_success(@user.as_json(except: [:password_digest]))
      else
        render_error(@user.errors.full_messages, :unprocessable_entity)
      end
    end
    
    # DELETE /api/v1/users/:id
    def destroy
      @user.destroy
      render_success({ message: 'User deleted successfully' })
    end
    
    private
    
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation, :name, :address, :role)
    end
  end