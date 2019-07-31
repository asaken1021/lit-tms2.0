class CreateUserNotifySettings < ActiveRecord::Migration[5.2]
  def change
    create_table :notify_days do |t|
      t.integer :user_id
      t.boolean :is_sunday
      t.boolean :is_monday
      t.boolean :is_tuesday
      t.boolean :is_wednesday
      t.boolean :is_thursday
      t.boolean :is_friday
      t.boolean :is_saturday
    end
  end
end
