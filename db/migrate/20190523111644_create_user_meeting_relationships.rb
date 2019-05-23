class CreateUserMeetingRelationships < ActiveRecord::Migration[5.2]
  def change
    create_table :user_meeting_relationships do |t|
      t.references :user, foreign_key: true
      t.references :meeting, foreign_key: true

      t.timestamps
    end
  end
end
