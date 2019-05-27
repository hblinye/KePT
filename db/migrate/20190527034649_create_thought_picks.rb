class CreateThoughtPicks < ActiveRecord::Migration[5.2]
  def change
    create_table :thought_picks do |t|
      t.references :user, foreign_key: true
      t.references :thought, foreign_key: true

      t.timestamps
    end
  end
end
