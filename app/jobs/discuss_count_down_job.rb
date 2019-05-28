class DiscussCountDownJob < ApplicationJob
    queue_as :discuss_count_down

    def perform(thought)
        thought.update!({discussing: 2})
        response_data = Hash.new
        response_data[:type] = 'discuss_time_up'
        response_data[:thought] = thought
        ActionCable.server.broadcast "meeting_#{thought.meeting_id}", response_data
    end
end