class CreateUserIdAndDays < ActiveRecord::Migration[5.2]
  def change
    create_table :user_days do |t|
      t.integer :user_id
      t.integer :day_id
      # 0 = Sunday
      # 1 = Monday
      # 2 = Tuesday
      # 3 = Wednesday
      # 4 = Thursday
      # 5 = Friday
      # 6 = Saturday
    end
  end
end
