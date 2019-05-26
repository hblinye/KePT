class EnterMeetingJob < ApplicationJob
    queue_as :enter_meeting

    def perform(um)
        um.update!({active: true})
        response_data = Hash.new
        response_data[:type] = 'enter'
        response_data[:data] = um.user
        ActionCable.server.broadcast "meeting_#{um.meeting_id}", response_data
    end
end