# app/controllers/api/v1/books_controller.rb
class Api::V1::BooksController < Api::V1::ApiController
    before_action :set_book, only: [:show, :update, :destroy]
    
    # GET /api/v1/books
    def index
      @books = Book.includes(:category)
      
      # Add filtering
      @books = @books.where(category_id: params[:category_id]) if params[:category_id].present?
      @books = @books.where("title ILIKE ?", "%#{params[:search]}%") if params[:search].present?
      @books = @books.where("price >= ?", params[:min_price]) if params[:min_price].present?
      @books = @books.where("price <= ?", params[:max_price]) if params[:max_price].present?
      
      # Add pagination
      page = params[:page] || 1
      per_page = params[:per_page] || 20
      @books = @books.page(page).per(per_page)
      
      render_success({
        books: @books,
        meta: {
          current_page: @books.current_page,
          total_pages: @books.total_pages,
          total_count: @books.total_count
        }
      })
    end
    
    # GET /api/v1/books/:id
    def show
      render_success(@book.as_json(include: :category))
    end
    
    # GET /api/v1/books/slug/:slug
    def show_by_slug
      @book = Book.includes(:category).find_by!(slug: params[:slug])
      render_success(@book.as_json(include: :category))
    end
    
    # POST /api/v1/books
    def create
      @book = Book.new(book_params)
      
      if @book.save
        render_success(@book.as_json(include: :category), :created)
      else
        render_error(@book.errors.full_messages, :unprocessable_entity)
      end
    end
    
    # PUT/PATCH /api/v1/books/:id
    def update
      if @book.update(book_params)
        render_success(@book.as_json(include: :category))
      else
        render_error(@book.errors.full_messages, :unprocessable_entity)
      end
    end
    
    # DELETE /api/v1/books/:id
    def destroy
      @book.destroy
      render_success({ message: 'Book deleted successfully' })
    end
    
    private
    
    def set_book
      @book = Book.includes(:category).find(params[:id])
    end
    
    def book_params
      params.require(:book).permit(
        :title, :author, :description, :price, :stock_quantity, 
        :isbn, :publisher, :publication_date, :page_count, 
        :language, :category_id
      )
    end
  end