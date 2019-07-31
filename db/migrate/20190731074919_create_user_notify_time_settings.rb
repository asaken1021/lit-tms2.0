class CreateUserNotifyTimeSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :notify_times do |t|
      t.integer :user_id
      t.boolean :notify_6to8
      t.boolean :notify_8to10
      t.boolean :notify_10to12
      t.boolean :notify_12to14
      t.boolean :notify_14to16
      t.boolean :notify_16to18
      t.boolean :notify_18to20
      t.boolean :notify_20to22
      t.boolean :notify_22to24
    end
  end
end
