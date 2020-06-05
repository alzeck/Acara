class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password
      t.datetime :dob
      t.string :posizione
      t.boolean :verificazione
      t.boolean :flagmail
      t.text :bio
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
