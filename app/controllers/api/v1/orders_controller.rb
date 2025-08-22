# app/controllers/api/v1/orders_controller.rb
class Api::V1::OrdersController < Api::V1::ApiController
    before_action :set_order, only: [:show, :update, :destroy]
    # Add authentication: before_action :authenticate_user!
    
    # GET /api/v1/orders
    def index
      # For now, get all orders. Later, filter by current_user
      @orders = Order.includes(:user, order_items: :book)
      @orders = @orders.where(user_id: params[:user_id]) if params[:user_id].present?
      @orders = @orders.where(status: params[:status]) if params[:status].present?
      
      render_success(@orders.as_json(
        include: {
          user: { except: [:password_digest] },
          order_items: {
            include: {
              book: { include: :category }
            }
          }
        }
      ))
    end
    
    # GET /api/v1/orders/:id
    def show
      render_success(@order.as_json(
        include: {
          user: { except: [:password_digest] },
          order_items: {
            include: {
              book: { include: :category }
            }
          }
        }
      ))
    end
    
    # POST /api/v1/orders
    def create
      @order = Order.new(order_params)
      
      if @order.save
        render_success(@order.as_json(include: :order_items), :created)
      else
        render_error(@order.errors.full_messages, :unprocessable_entity)
      end
    end
    
    # PUT/PATCH /api/v1/orders/:id
    def update
      if @order.update(order_params)
        render_success(@order)
      else
        render_error(@order.errors.full_messages, :unprocessable_entity)
      end
    end
    
    # DELETE /api/v1/orders/:id
    def destroy
      @order.destroy
      render_success({ message: 'Order deleted successfully' })
    end
    
    private
    
    def set_order
      @order = Order.includes(:user, order_items: :book).find(params[:id])
    end
    
    def order_params
      params.require(:order).permit(:user_id, :total_amount, :status, :shipping_address)
    end
  end