class CountDownJob < ApplicationJob
    queue_as :count_down

    def perform(um)
        meeting = Meeting.find(um.meeting_id)
        meeting.update!({status: meeting.status + 1})
        response_data = Hash.new
        response_data[:type] = 'timeup'
        response_data[:data] = meeting.status
        ActionCable.server.broadcast "meeting_#{um.meeting_id}", response_data
    end
end