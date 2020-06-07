class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :where
      t.string :cords
      t.datetime :start
      t.datetime :end
      t.string :title
      t.text :description
      t.boolean :modified
      t.references :user, null: false, foreign_key: true
    end
  end
end
