# db/seeds.rb
CartItem.destroy_all
OrderItem.destroy_all
Cart.destroy_all
Order.destroy_all
Book.destroy_all
Category.destroy_all
User.destroy_all

# Create Categories
fiction = Category.create!(
  name: "Fiction",
  description: "Fictional books and novels"
)

non_fiction = Category.create!(
  name: "Non-Fiction", 
  description: "Educational and informational books"
)

tech = Category.create!(
  name: "Technology",
  description: "Programming and tech-related books"
)

# Create Users
admin = User.create!(
  email: "admin@bookstore.com",
  password: "password123",
  password_confirmation: "password123",
  name: "Admin User",
  address: "123 Admin St, Admin City",
  role: "admin"
)

customer = User.create!(
  email: "customer@example.com", 
  password: "password123",
  password_confirmation: "password123",
  name: "John Doe",
  address: "456 Customer Ave, Customer City",
  role: "customer"
)

# Create Books
Book.create!([
  {
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    description: "A classic American novel",
    price: 12.99,
    stock_quantity: 50,
    isbn: "978-0-7432-7356-5",
    publisher: "Scribner",
    publication_date: Date.new(1925, 4, 10),
    page_count: 180,
    language: "English",
    category: fiction
  },
  {
    title: "Clean Code",
    author: "Robert C. Martin",
    description: "A handbook of agile software craftsmanship",
    price: 45.99,
    stock_quantity: 25,
    isbn: "978-0-13-235088-4", 
    publisher: "Prentice Hall",
    publication_date: Date.new(2008, 8, 1),
    page_count: 464,
    language: "English",
    category: tech
  },
  {
    title: "Sapiens",
    author: "Yuval Noah Harari",
    description: "A brief history of humankind",
    price: 16.99,
    stock_quantity: 30,
    isbn: "978-0-06-231609-7",
    publisher: "Harper",
    publication_date: Date.new(2015, 2, 10),
    page_count: 443,
    language: "English", 
    category: non_fiction
  }
])

# Create a cart for the customer
cart = Cart.create!(user: customer)

puts "Seed data created successfully!"
puts "Categories: #{Category.count}"
puts "Users: #{User.count}" 
puts "Books: #{Book.count}"
puts "Carts: #{Cart.count}"