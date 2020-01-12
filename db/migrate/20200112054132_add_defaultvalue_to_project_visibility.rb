class AddDefaultvalueToProjectVisibility < ActiveRecord::Migration[5.2]
  def change
    change_column :projects, :visibility, :string, default: "public"
  end
end
