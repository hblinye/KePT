class LeaveMeetingJob < ApplicationJob
    queue_as :default

    def perform(um)
        if target_um = UserMeetingRelationship.find_by({id: um.id, active: false})
            response_data = Hash.new
            response_data[:type] = 'leave'
            response_data[:data] = target_um.user_id
            ActionCable.server.broadcast "meeting_#{target_um.meeting_id}", response_data
        end
    end
end