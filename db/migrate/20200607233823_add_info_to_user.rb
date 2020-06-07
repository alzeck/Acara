class AddInfoToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :birthday, :date
    add_column :users, :position, :string, default: ""
    add_column :users, :verification, :boolean, default: false
    add_column :users, :bio, :text, default: ""
  end
end
