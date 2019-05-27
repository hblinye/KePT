class AfterPickJob < ApplicationJob
    queue_as :pick_up


    def perform(thought_pick)
        response_data = Hash.new
        response_data[:type] = 'pick_up'
        response_data[:data] = thought_pick.thought_id
        ActionCable.server.broadcast "meeting_#{thought_pick.thought.meeting_id}", response_data
    end
end