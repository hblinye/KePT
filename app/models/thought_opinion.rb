class ThoughtOpinion < ApplicationRecord
  after_create_commit { SendOpinionJob.perform_later self }
  belongs_to :user
  belongs_to :thought
end
