class Thought < ApplicationRecord
  after_create_commit { AfterSubmitJob.perform_later self }
  belongs_to :user
  belongs_to :meeting
end
