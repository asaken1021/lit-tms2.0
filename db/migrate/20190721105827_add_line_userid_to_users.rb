class AddLineUseridToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :user_line_id, :string
  end
end
