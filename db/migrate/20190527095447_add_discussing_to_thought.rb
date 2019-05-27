class AddDiscussingToThought < ActiveRecord::Migration[5.2]
  def change
    add_column :thoughts, :discussing, :integer, default: 0
  end
end
