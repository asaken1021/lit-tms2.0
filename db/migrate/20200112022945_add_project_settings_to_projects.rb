class AddProjectSettingsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :visibility, :string
  end
end
