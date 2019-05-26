class MeetingChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "meeting_#{current_user[:um].meeting_id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    um = current_user[:um]
    um.update!({active: false})
    LeaveMeetingJob.set(wait: 5.second).perform_later um
  end

  def submit(data)
    # if meeting = Meeting.find_by({id: current_user[:um].meeting_id, status: 1})
    #   Thought.create!({
    #     content: data['thought'],
    #     ttype: data['type'].to_i,
    #     user_id: current_user[:um].user_id,
    #     meeting_id: meeting.id
    #   })
    # end
    
    Thought.create!({
      content: data['thought'],
      ttype: data['type'].to_i,
      user_id: current_user[:um].user_id,
      meeting_id: current_user[:um].meeting_id
    })
  end

  def timing_start(data)
    meeting = current_user[:um].meeting
    meeting.update!({status: meeting.status + 1})
    response_data = Hash.new
    response_data[:type] = 'timingStart'
    response_data[:data] = Hash.new
    response_data[:data][:second] = data['second'].to_i
    response_data[:data][:status] = meeting.status
    ActionCable.server.broadcast "meeting_#{meeting.id}", response_data
    CountDownJob.set(wait: data['second'].to_i.second).perform_later current_user[:um]
  end

  def delete_thought(data)
    if thought = Thought.find_by({ id: data['id'], user_id: current_user[:um].user_id, meeting_id: current_user[:um].meeting_id })
      response_data = Hash.new
      response_data[:type] = 'delete'
      response_data[:data] = thought.id
      ActionCable.server.broadcast "meeting_#{thought.meeting_id}", response_data
      thought.destroy
    end
  end
end
