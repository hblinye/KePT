class SendOpinionJob < ApplicationJob
    queue_as :send_opinion

    def perform(thought_opinion)
        response_data = Hash.new
        response_data[:type] = 'send_opinion'
        response_data[:data] = thought_opinion
        ActionCable.server.broadcast "meeting_#{thought_opinion.thought.meeting_id}", response_data
    end
end