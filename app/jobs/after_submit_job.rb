class AfterSubmitJob < ApplicationJob
    queue_as :submit

    def perform(thought)
        response_data = Hash.new
        response_data[:type] = 'submit'
        response_data[:data] = Hash.new
        response_data[:data][:thought] = thought
        response_data[:data][:user] = thought.user
        ActionCable.server.broadcast "meeting_#{thought.meeting_id}", response_data
    end
end