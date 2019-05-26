class AddStatusToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :status, :integer, default: 0
  end
end
