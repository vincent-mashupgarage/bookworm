# app/controllers/api/v1/categories_controller.rb
class Api::V1::CategoriesController < Api::V1::ApiController
    before_action :set_category, only: [:show, :update, :destroy]
    
    # GET /api/v1/categories
    def index
      @categories = Category.all
      render_success(@categories)
    end
    
    # GET /api/v1/categories/:id
    def show
      render_success(@category)
    end
    
    # POST /api/v1/categories
    def create
      @category = Category.new(category_params)
      
      if @category.save
        render_success(@category, :created)
      else
        render_error(@category.errors.full_messages, :unprocessable_entity)
      end
    end
    
    # PUT/PATCH /api/v1/categories/:id
    def update
      if @category.update(category_params)
        render_success(@category)
      else
        render_error(@category.errors.full_messages, :unprocessable_entity)
      end
    end
    
    # DELETE /api/v1/categories/:id
    def destroy
      @category.destroy
      render_success({ message: 'Category deleted successfully' })
    end
    
    private
    
    def set_category
      @category = Category.find(params[:id])
    end
    
    def category_params
      params.require(:category).permit(:name, :description)
    end
  end