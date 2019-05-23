class User < ApplicationRecord
    validates :name, presence: true
    validates :skey, presence: true
    has_many :user_meeting_relationships
    has_many :meetings, through: :user_meeting_relationships
    has_many :thoughts
end
