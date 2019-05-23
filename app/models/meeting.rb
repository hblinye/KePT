class Meeting < ApplicationRecord
    has_many :user_meeting_relationships
    has_many :users, through: :user_meeting_relationships
    has_many :thoughts
end
