class CreateUserActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :user_activities do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :phase_id
      t.integer :task_id
      t.string :activity
      t.timestamps null: false
    end
  end
end
