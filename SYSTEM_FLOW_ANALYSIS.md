# Bookworm E-commerce System Flow Analysis

## Application Flow Diagram

```mermaid
graph TB
    %% External Actors
    Customer[Customer]
    Admin[Admin]
    
    %% API Layer
    subgraph "API Layer (/api/v1/)"
        ApiController[Api::V1::ApiController<br/>Base Controller]
        BooksAPI[Books Controller]
        CategoriesAPI[Categories Controller]
        UsersAPI[Users Controller]
        CartsAPI[Carts Controller]
        OrdersAPI[Orders Controller]
        CartItemsAPI[Cart Items Controller]
        OrderItemsAPI[Order Items Controller]
    end
    
    %% Business Logic Layer
    subgraph "Models & Business Logic"
        UserModel[User Model<br/>- Authentication<br/>- Role Management]
        BookModel[Book Model<br/>- Inventory<br/>- Slug Generation]
        CategoryModel[Category Model<br/>- Hierarchy]
        CartModel[Cart Model<br/>- User Association]
        CartItemModel[Cart Item Model<br/>- Quantity Validation]
        OrderModel[Order Model<br/>- Status Tracking]
        OrderItemModel[Order Item Model<br/>- Price History]
    end
    
    %% Data Layer
    subgraph "Database (PostgreSQL)"
        UsersTable[(users)]
        BooksTable[(books)]
        CategoriesTable[(categories)]
        CartsTable[(carts)]
        CartItemsTable[(cart_items)]
        OrdersTable[(orders)]
        OrderItemsTable[(order_items)]
    end
    
    %% Flow Connections
    Customer --> BooksAPI
    Customer --> CartsAPI
    Customer --> OrdersAPI
    Customer --> UsersAPI
    
    Admin --> BooksAPI
    Admin --> CategoriesAPI
    Admin --> OrdersAPI
    Admin --> UsersAPI
    
    %% API to Models
    BooksAPI --> BookModel
    CategoriesAPI --> CategoryModel
    UsersAPI --> UserModel
    CartsAPI --> CartModel
    OrdersAPI --> OrderModel
    CartItemsAPI --> CartItemModel
    OrderItemsAPI --> OrderItemModel
    
    %% Models to Database
    UserModel --> UsersTable
    BookModel --> BooksTable
    CategoryModel --> CategoriesTable
    CartModel --> CartsTable
    CartItemModel --> CartItemsTable
    OrderModel --> OrdersTable
    OrderItemModel --> OrderItemsTable
    
    %% Relationships
    UsersTable -.-> CartsTable
    UsersTable -.-> OrdersTable
    CategoriesTable -.-> BooksTable
    CartsTable -.-> CartItemsTable
    BooksTable -.-> CartItemsTable
    OrdersTable -.-> OrderItemsTable
    BooksTable -.-> OrderItemsTable
```

## Customer Purchase Flow

```mermaid
graph TB
    Start[Customer Visits Store]
    
    %% Browse Books
    Browse[Browse Books<br/>GET /api/v1/books]
    Filter[Apply Filters<br/>?category_id=X&search=Y]
    ViewBook[View Book Details<br/>GET /api/v1/books/:id]
    
    %% Authentication
    Auth{Authenticated?}
    Register[Register<br/>POST /api/v1/users]
    Login[Login Process]
    
    %% Cart Management
    GetCart[Get User Cart<br/>GET /api/v1/users/:user_id/cart]
    CreateCart[Create Cart<br/>POST /api/v1/users/:user_id/cart]
    AddToCart[Add to Cart<br/>POST /api/v1/carts/:id/cart_items]
    UpdateCart[Update Quantities<br/>PATCH /api/v1/carts/:id/cart_items/:id]
    ViewCart[Review Cart<br/>GET /api/v1/carts/:id]
    
    %% Checkout Process
    Checkout[Proceed to Checkout]
    CreateOrder[Create Order<br/>POST /api/v1/orders]
    AddOrderItems[Add Order Items<br/>POST /api/v1/orders/:id/order_items]
    ProcessPayment[Process Payment<br/>External Integration]
    UpdateStatus[Update Order Status<br/>PATCH /api/v1/orders/:id]
    ClearCart[Clear Cart<br/>DELETE /api/v1/carts/:id/clear]
    
    %% Order Tracking
    OrderComplete[Order Confirmation]
    TrackOrder[Track Order<br/>GET /api/v1/orders/:id]
    
    %% Flow
    Start --> Browse
    Browse --> Filter
    Filter --> ViewBook
    ViewBook --> Auth
    
    Auth -->|No| Register
    Auth -->|No| Login
    Register --> GetCart
    Login --> GetCart
    Auth -->|Yes| GetCart
    
    GetCart -->|Cart Exists| AddToCart
    GetCart -->|No Cart| CreateCart
    CreateCart --> AddToCart
    
    AddToCart --> UpdateCart
    UpdateCart --> ViewCart
    ViewCart --> Checkout
    
    Checkout --> CreateOrder
    CreateOrder --> AddOrderItems
    AddOrderItems --> ProcessPayment
    ProcessPayment --> UpdateStatus
    UpdateStatus --> ClearCart
    ClearCart --> OrderComplete
    OrderComplete --> TrackOrder
```

## Admin Management Flow

```mermaid
graph TB
    AdminLogin[Admin Login]
    Dashboard[Admin Dashboard]
    
    %% Book Management
    BookMgmt[Book Management]
    ListBooks[List All Books<br/>GET /api/v1/books]
    CreateBook[Create New Book<br/>POST /api/v1/books]
    EditBook[Edit Book<br/>PATCH /api/v1/books/:id]
    DeleteBook[Delete Book<br/>DELETE /api/v1/books/:id]
    
    %% Category Management
    CatMgmt[Category Management]
    ListCats[List Categories<br/>GET /api/v1/categories]
    CreateCat[Create Category<br/>POST /api/v1/categories]
    EditCat[Edit Category<br/>PATCH /api/v1/categories/:id]
    
    %% Order Management
    OrderMgmt[Order Management]
    ListOrders[List All Orders<br/>GET /api/v1/orders]
    ViewOrder[View Order Details<br/>GET /api/v1/orders/:id]
    UpdateOrderStatus[Update Status<br/>PATCH /api/v1/orders/:id]
    
    %% User Management
    UserMgmt[User Management]
    ListUsers[List Users<br/>GET /api/v1/users]
    ViewUser[View User<br/>GET /api/v1/users/:id]
    UpdateUser[Update User<br/>PATCH /api/v1/users/:id]
    
    %% Flow
    AdminLogin --> Dashboard
    Dashboard --> BookMgmt
    Dashboard --> CatMgmt
    Dashboard --> OrderMgmt
    Dashboard --> UserMgmt
    
    BookMgmt --> ListBooks
    BookMgmt --> CreateBook
    BookMgmt --> EditBook
    BookMgmt --> DeleteBook
    
    CatMgmt --> ListCats
    CatMgmt --> CreateCat
    CatMgmt --> EditCat
    
    OrderMgmt --> ListOrders
    OrderMgmt --> ViewOrder
    OrderMgmt --> UpdateOrderStatus
    
    UserMgmt --> ListUsers
    UserMgmt --> ViewUser
    UserMgmt --> UpdateUser
```

## Data Relationship Flow

```mermaid
erDiagram
    USER {
        id bigint PK
        email string UK
        password_digest string
        name string
        address text
        role string
        created_at datetime
        updated_at datetime
    }
    
    CATEGORY {
        id bigint PK
        name string UK
        description text
        created_at datetime
        updated_at datetime
    }
    
    BOOK {
        id bigint PK
        title string
        author string
        description text
        price decimal
        stock_quantity integer
        isbn string UK
        publisher string
        publication_date date
        page_count integer
        language string
        slug string UK
        category_id bigint FK
        created_at datetime
        updated_at datetime
    }
    
    CART {
        id bigint PK
        user_id bigint FK
        created_at datetime
        updated_at datetime
    }
    
    CART_ITEM {
        id bigint PK
        cart_id bigint FK
        book_id bigint FK
        quantity integer
        created_at datetime
        updated_at datetime
    }
    
    ORDER {
        id bigint PK
        user_id bigint FK
        total_amount decimal
        status string
        shipping_address text
        created_at datetime
        updated_at datetime
    }
    
    ORDER_ITEM {
        id bigint PK
        order_id bigint FK
        book_id bigint FK
        quantity integer
        price_at_purchase decimal
        created_at datetime
        updated_at datetime
    }
    
    USER ||--o{ CART : "has many"
    USER ||--o{ ORDER : "places"
    CATEGORY ||--o{ BOOK : "contains"
    CART ||--o{ CART_ITEM : "contains"
    BOOK ||--o{ CART_ITEM : "added to"
    ORDER ||--o{ ORDER_ITEM : "contains"
    BOOK ||--o{ ORDER_ITEM : "purchased as"
```

## Request/Response Flow

```mermaid
sequenceDiagram
    participant C as Client
    participant API as API Controller
    participant M as Model
    participant DB as Database
    
    Note over C,DB: Book Browsing Flow
    C->>API: GET /api/v1/books?category_id=1&search=ruby
    API->>M: Book.includes(:category)
    M->>DB: SELECT books.*, categories.* WHERE...
    DB-->>M: Book records with categories
    M-->>API: @books with pagination
    API-->>C: JSON response with books & meta
    
    Note over C,DB: Add to Cart Flow
    C->>API: POST /api/v1/carts/1/cart_items
    API->>M: CartItem.new(cart_id, book_id, quantity)
    M->>DB: INSERT INTO cart_items...
    DB-->>M: Created cart_item
    M-->>API: @cart_item
    API-->>C: JSON success response
    
    Note over C,DB: Order Creation Flow
    C->>API: POST /api/v1/orders
    API->>M: Order.new(user_id, total_amount)
    M->>DB: BEGIN TRANSACTION
    M->>DB: INSERT INTO orders...
    M->>DB: INSERT INTO order_items...
    M->>DB: UPDATE books SET stock_quantity...
    M->>DB: COMMIT TRANSACTION
    DB-->>M: Order with items created
    M-->>API: @order with order_items
    API-->>C: JSON order confirmation
```

## Error Handling Flow

```mermaid
graph TB
    Request[API Request]
    Controller[Controller Action]
    
    %% Error Types
    NotFound{Record Not Found?}
    ValidationError{Validation Error?}
    AuthError{Authentication Error?}
    ServerError{Server Error?}
    
    %% Error Handlers
    NotFoundHandler[404 Not Found<br/>record_not_found]
    ValidationHandler[422 Unprocessable Entity<br/>record_invalid]
    AuthHandler[401 Unauthorized<br/>authentication_required]
    ServerHandler[500 Internal Server Error<br/>application_error]
    
    %% Success
    Success[200/201 Success<br/>render_success]
    
    Request --> Controller
    Controller --> NotFound
    Controller --> ValidationError
    Controller --> AuthError
    Controller --> ServerError
    Controller --> Success
    
    NotFound -->|Yes| NotFoundHandler
    ValidationError -->|Yes| ValidationHandler
    AuthError -->|Yes| AuthHandler
    ServerError -->|Yes| ServerHandler
    
    NotFound -->|No| ValidationError
    ValidationError -->|No| AuthError
    AuthError -->|No| ServerError
    ServerError -->|No| Success
```

## Key Features Summary

### 1. **RESTful API Design**
- Consistent JSON responses via `render_success` and `render_error`
- Proper HTTP status codes
- Nested resources (orders/order_items, carts/cart_items)

### 2. **Data Integrity**
- Foreign key constraints
- Unique indexes on critical fields (email, ISBN, slug)
- Model validations for business rules

### 3. **Search & Filtering**
- Category-based filtering
- Text search on book titles
- Price range filtering
- Pagination support

### 4. **Shopping Cart Features**
- User-specific carts
- Quantity management
- Cart clearing functionality
- Cart persistence across sessions

### 5. **Order Management**
- Order status tracking (pending → processing → shipped → delivered)
- Price history preservation
- Order item management

### 6. **Security Features**
- Password encryption via `has_secure_password`
- Role-based access (admin/customer)
- CSRF protection disabled for API
- Parameter filtering for sensitive data

### 7. **Business Logic**
- Automatic slug generation for books
- Stock quantity management
- Total amount calculations
- User role validation

This system provides a solid foundation for an e-commerce book store with room for future enhancements like payment processing, advanced search, recommendations, and inventory alerts.