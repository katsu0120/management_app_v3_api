class CreateProjects < ActiveRecord::Migration[6.1]
  def change
    create_table :projects do |t|
      t.references :company, foreing_key: true
      t.references :user, foreing_key: true, null: false
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
