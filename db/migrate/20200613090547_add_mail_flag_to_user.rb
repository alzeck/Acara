class AddMailFlagToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :mailflag, :boolean, default: true
  end
end
