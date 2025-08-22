class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :author, null: false
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :stock_quantity, default: 0
      t.string :isbn
      t.string :publisher
      t.date :publication_date
      t.integer :page_count
      t.string :language, default: 'English'
      t.string :slug
      t.references :category, null: false, foreign_key: true

      t.timestamps
    end

    add_index :books, :isbn, unique: true
    add_index :books, :slug, unique: true
  end
end
