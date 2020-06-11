class CreateFollowsTags < ActiveRecord::Migration[6.0]
  def change
    create_table :follows_tags do |t|
      t.references :user, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true
    end
  end
end
