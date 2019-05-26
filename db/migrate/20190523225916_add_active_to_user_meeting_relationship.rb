class AddActiveToUserMeetingRelationship < ActiveRecord::Migration[5.2]
  def change
    add_column :user_meeting_relationships, :active, :boolean, default: true
  end
end
