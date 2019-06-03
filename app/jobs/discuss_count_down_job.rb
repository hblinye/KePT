class DiscussCountDownJob < ApplicationJob
    queue_as :discuss_count_down

    def perform(thought)
        if now_thought = Thought.find(thought.id)
            if now_thought.discussing == 1
                now_thought.update!({discussing: 2})
                response_data = Hash.new
                response_data[:type] = 'discuss_time_up'
                response_data[:data] = now_thought
                ActionCable.server.broadcast "meeting_#{now_thought.meeting_id}", response_data
            end
        end
    end
end