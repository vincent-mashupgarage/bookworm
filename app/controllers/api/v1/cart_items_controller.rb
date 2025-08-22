# app/controllers/api/v1/cart_items_controller.rb
class Api::V1::CartItemsController < Api::V1::ApiController
    before_action :set_cart
    before_action :set_cart_item, only: [:show, :update, :destroy]
    
    # GET /api/v1/carts/:cart_id/cart_items
    def index
      @cart_items = @cart.cart_items.includes(:book)
      render_success(@cart_items.as_json(include: { book: { include: :category } }))
    end
    
    # GET /api/v1/carts/:cart_id/cart_items/:id
    def show
      render_success(@cart_item.as_json(include: { book: { include: :category } }))
    end
    
    # POST /api/v1/carts/:cart_id/cart_items
    def create
      # Check if item already exists in cart
      existing_item = @cart.cart_items.find_by(book_id: cart_item_params[:book_id])
      
      if existing_item
        # Update quantity instead of creating new item
        new_quantity = existing_item.quantity + cart_item_params[:quantity].to_i
        if existing_item.update(quantity: new_quantity)
          render_success(existing_item.as_json(include: { book: { include: :category } }))
        else
          render_error(existing_item.errors.full_messages, :unprocessable_entity)
        end
      else
        # Create new cart item
        @cart_item = @cart.cart_items.build(cart_item_params)
        
        if @cart_item.save
          render_success(@cart_item.as_json(include: { book: { include: :category } }), :created)
        else
          render_error(@cart_item.errors.full_messages, :unprocessable_entity)
        end
      end
    end
    
    # PUT/PATCH /api/v1/carts/:cart_id/cart_items/:id
    def update
      if @cart_item.update(cart_item_params)
        render_success(@cart_item.as_json(include: { book: { include: :category } }))
      else
        render_error(@cart_item.errors.full_messages, :unprocessable_entity)
      end
    end
    
    # DELETE /api/v1/carts/:cart_id/cart_items/:id
    def destroy
      @cart_item.destroy
      render_success({ message: 'Item removed from cart successfully' })
    end
    
    private
    
    def set_cart
      @cart = Cart.find(params[:cart_id])
    end
    
    def set_cart_item
      @cart_item = @cart.cart_items.find(params[:id])
    end
    
    def cart_item_params
      params.require(:cart_item).permit(:book_id, :quantity)
    end
  end