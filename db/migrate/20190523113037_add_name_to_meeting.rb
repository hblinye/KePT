class AddNameToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :name, :string
  end
end
