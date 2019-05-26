class CreateThoughts < ActiveRecord::Migration[5.2]
  def change
    create_table :thoughts do |t|
      t.string :content
      t.integer :ttype
      t.references :user, foreign_key: true
      t.references :meeting, foreign_key: true

      t.timestamps
    end
  end
end
