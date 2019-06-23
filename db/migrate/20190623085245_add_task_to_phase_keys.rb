class AddTaskToPhaseKeys < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :phase_id, :integer
  end
end
