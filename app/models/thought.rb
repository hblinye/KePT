class Thought < ApplicationRecord
  after_create_commit { AfterSubmitJob.perform_later self }
  belongs_to :user
  belongs_to :meeting
  has_many :thought_picks
  has_many :thought_opinions
end
