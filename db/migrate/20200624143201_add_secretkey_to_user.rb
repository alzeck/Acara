class AddSecretkeyToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :secretkey, :string
  end
end
