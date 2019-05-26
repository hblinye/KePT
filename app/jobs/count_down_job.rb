class CountDownJob < ApplicationJob
    queue_as :count_down

    def perform(um)
        response_data = Hash.new
        response_data[:type] = 'timeup'
        response_data[:data] = um.meeting.status
        ActionCable.server.broadcast "meeting_#{um.meeting_id}", response_data
    end
end