class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :name, null: false
      t.text :address, null: false
      t.string :role, default: 'customer'

      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
