# app/controllers/api/v1/carts_controller.rb
class Api::V1::CartsController < Api::V1::ApiController
    before_action :set_cart, only: [:show, :update, :destroy, :clear]
    # Add authentication: before_action :authenticate_user!
    
    # GET /api/v1/users/:user_id/cart
    def show
      render_success(@cart.as_json(
        include: {
          cart_items: {
            include: {
              book: { include: :category }
            }
          }
        }
      ))
    end
    
    # POST /api/v1/users/:user_id/cart
    def create
      @cart = Cart.new(user_id: params[:user_id])
      
      if @cart.save
        render_success(@cart, :created)
      else
        render_error(@cart.errors.full_messages, :unprocessable_entity)
      end
    end


    def update
      if @cart.update(cart_params)
        render_success(@cart.as_json(
          include: {
            cart_items: {
              include: {
                book: { include: :category }
              }
            }
          }
        ))
      else
        render_error(@cart.errors.full_messages, :unprocessable_entity)
      end
    end
    
    # DELETE /api/v1/carts/:id/clear
    def clear
      @cart.cart_items.destroy_all
      render_success({ message: 'Cart cleared successfully' })
    end
    
    # DELETE /api/v1/carts/:id
    def destroy
      @cart.destroy
      render_success({ message: 'Cart deleted successfully' })
    end
    
    private
    
    def set_cart
      if params[:user_id]
        @cart = Cart.includes(cart_items: { book: :category }).find_by!(user_id: params[:user_id])
      else
        @cart = Cart.includes(cart_items: { book: :category }).find(params[:id])
      end
    end
  end