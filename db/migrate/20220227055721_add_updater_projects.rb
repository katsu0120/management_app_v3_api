class AddUpdaterProjects < ActiveRecord::Migration[6.1]
  def change
    add_column :projects, :updater, :string
  end
end
