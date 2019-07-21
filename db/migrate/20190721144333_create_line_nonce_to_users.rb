class CreateLineNonceToUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :nonces do |t|
      t.string :nonce
      t.integer :user_id
      t.timestamps null: false
    end
  end
end