class CreateFlags < ActiveRecord::Migration[6.0]
  def change
    create_table :flags do |t|
      t.string :reason
      t.text :description
      t.references :flaggedEvent, null: true, references: :events, foreign_key: { to_table: :events}
      t.references :flaggedComment, null: true, references: :comments, foreign_key: { to_table: :comments}
      t.references :flaggedUser, null: true, references: :users, foreign_key: { to_table: :users}
      
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
