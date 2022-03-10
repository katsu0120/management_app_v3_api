class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.references :project, foreing_key: true, null: false
      t.string :title, null: false
      t.string :content, null: false
      t.string :updater
      t.boolean :completed, null: false, default: false

      t.timestamps
    end
  end
end
