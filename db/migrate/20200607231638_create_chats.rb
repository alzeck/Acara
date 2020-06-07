class CreateChats < ActiveRecord::Migration[6.0]
  def change
    create_table :chats do |t|
      t.references :user1, null: false, references: :users, foreign_key: { to_table: :users}
      t.references :user2, null: false, references: :users, foreign_key: { to_table: :users}
    end
  end
end
