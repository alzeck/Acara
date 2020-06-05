class CreateHasTags < ActiveRecord::Migration[6.0]
  def change
    create_table :has_tags, id:false do |t|
      t.references :tag, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
    end
  end
end
