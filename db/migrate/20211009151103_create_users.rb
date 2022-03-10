class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :refresh_jti
      t.text :user_profile
      t.boolean :activated, null: false, default: false
      t.boolean :admin, null: false, default: false
      t.timestamps
    end
    add_index :users, :name, unique: true
  end
end
