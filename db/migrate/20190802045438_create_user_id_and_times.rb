class CreateUserIdAndTimes < ActiveRecord::Migration[5.2]
  def change
    create_table :user_times do |t|
      t.integer :user_id
      t.integer :time_id
      # 0 = 6 ~ 8
      # 1 = 8 ~ 10
      # 2 = 10 ~ 12
      # 3 = 12 ~ 14
      # 4 = 14 ~ 16
      # 5 = 16 ~ 18
      # 6 = 18 ~ 20
      # 7 = 20 ~ 22
      # 8 = 22 ~ 24
    end
  end
end
