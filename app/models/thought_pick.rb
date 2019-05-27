class ThoughtPick < ApplicationRecord
  after_create_commit { AfterPickJob.perform_later self }
  belongs_to :user
  belongs_to :thought
end
