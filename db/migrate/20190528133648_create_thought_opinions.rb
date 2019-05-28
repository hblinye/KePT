class CreateThoughtOpinions < ActiveRecord::Migration[5.2]
  def change
    create_table :thought_opinions do |t|
      t.references :user, foreign_key: true
      t.references :thought, foreign_key: true
      t.integer :opinion, default: 0

      t.timestamps
    end
  end
end
