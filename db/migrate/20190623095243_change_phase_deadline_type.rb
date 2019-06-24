class ChangePhaseDeadlineType < ActiveRecord::Migration[5.2]
  def change
    change_column :phases, :deadline, :date
  end
end
