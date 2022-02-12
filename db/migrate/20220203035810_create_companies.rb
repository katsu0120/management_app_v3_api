class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.references :owner, foreign_key: { to_table: :users }, null: false
      t.string :name, null: false

      t.timestamps
    end
  end
end
