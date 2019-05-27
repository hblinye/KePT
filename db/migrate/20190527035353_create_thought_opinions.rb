class CreateThoughtOpinions < ActiveRecord::Migration[5.2]
  def change
    create_table :thought_opinions do |t|
      t.references :user, foreign_key: true
      t.references :thought, foreign_key: true
      t.boolean :opinion, default: false

      t.timestamps
    end
  end
end
