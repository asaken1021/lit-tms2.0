class ChangeProjectProgressIntToFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :projects, :progress, :float
  end
end
