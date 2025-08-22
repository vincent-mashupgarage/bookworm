# app/controllers/api/v1/order_items_controller.rb
class Api::V1::OrderItemsController < Api::V1::ApiController
    before_action :set_order
    before_action :set_order_item, only: [:show, :update, :destroy]
    
    # GET /api/v1/orders/:order_id/order_items
    def index
      @order_items = @order.order_items.includes(:book)
      render_success(@order_items.as_json(include: :book))
    end
    
    # GET /api/v1/orders/:order_id/order_items/:id
    def show
      render_success(@order_item.as_json(include: :book))
    end
    
    # POST /api/v1/orders/:order_id/order_items
    def create
      @order_item = @order.order_items.build(order_item_params)
      
      if @order_item.save
        render_success(@order_item.as_json(include: :book), :created)
      else
        render_error(@order_item.errors.full_messages, :unprocessable_entity)
      end
    end
    
    # PUT/PATCH /api/v1/orders/:order_id/order_items/:id
    def update
      if @order_item.update(order_item_params)
        render_success(@order_item.as_json(include: :book))
      else
        render_error(@order_item.errors.full_messages, :unprocessable_entity)
      end
    end
    
    # DELETE /api/v1/orders/:order_id/order_items/:id
    def destroy
      @order_item.destroy
      render_success({ message: 'Order item removed successfully' })
    end
    
    private
    
    def set_order
      @order = Order.find(params[:order_id])
    end
    
    def set_order_item
      @order_item = @order.order_items.find(params[:id])
    end
    
    def order_item_params
      params.require(:order_item).permit(:book_id, :quantity, :price_at_purchase)
    end
  end