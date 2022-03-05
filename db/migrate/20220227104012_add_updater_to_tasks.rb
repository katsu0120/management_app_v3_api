class AddUpdaterToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :updater, :string
  end
end
