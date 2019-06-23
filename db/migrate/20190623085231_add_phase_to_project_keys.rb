class AddPhaseToProjectKeys < ActiveRecord::Migration[5.2]
  def change
    add_column :phases, :project_id, :integer
  end
end
