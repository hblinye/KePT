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
    if meeting = Meeting.find_by({id: current_user[:um].meeting_id, status: 1})
      Thought.create!({
        content: data['thought'],
        ttype: data['type'].to_i,
        user_id: current_user[:um].user_id,
        meeting_id: meeting.id
      })
    end
  end

  def timing_start(data)
    meeting = Meeting.find(current_user[:um].meeting_id)
    meeting.update!({status: meeting.status + 1})
    response_data = Hash.new
    response_data[:type] = 'timingStart'
    response_data[:data] = Hash.new
    response_data[:data][:status] = meeting.status
    if meeting.status >= 7
      thoughts_ids = Thought.where({meeting_id: meeting.id, discussing: 0, ttype: 2}).ids
      if thoughts_ids.length <= 0
        thoughts_ids = Thought.where({meeting_id: meeting.id, discussing: 0, ttype: 3}).ids
      end
      most_picked_ids = ThoughtPick.where(thought_id: thoughts_ids).group('thought_id').order('count_user_id desc').count('user_id').first
      if most_picked_ids.length > 0
        response_data[:data][:thought] = Hash.new
        thought = Thought.find(most_picked_ids[0])
        thought.update!({discussing: 1})
        response_data[:data][:thought][:thought] = thought
        response_data[:data][:thought][:user] = thought.user
      end
    else
      response_data[:data][:second] = data['second'].to_i
      CountDownJob.set(wait: data['second'].to_i.second).perform_later current_user[:um]
    end
    ActionCable.server.broadcast "meeting_#{meeting.id}", response_data
  end

  def delete_thought(data)
    if thought = Thought.find_by({ id: data['id'].to_i, user_id: current_user[:um].user_id, meeting_id: current_user[:um].meeting_id })
      response_data = Hash.new
      response_data[:type] = 'delete'
      response_data[:data] = thought.id
      ActionCable.server.broadcast "meeting_#{thought.meeting_id}", response_data
      thought.destroy
    end
  end

  def push_time(data)
    response_data = Hash.new
    response_data[:type] = 'pushTime'
    response_data[:data] = data['second']
    ActionCable.server.broadcast "meeting_#{current_user[:um].meeting_id}", response_data
  end

  def pick_thought(data)
    if !ThoughtPick.exists?({thought_id: data['id'].to_i, user_id: current_user[:um].user_id})
      ThoughtPick.create!({thought_id: data['id'].to_i, user_id: current_user[:um].user_id})
    end
  end

  def start_discuss(data)
    if second = data['second'].to_i
      if thought = Thought.find_by({id: data['id'].to_i})
        thought.update!({discussing: 1})
        thought.thought_opinions.each do |opinion| opinion.destroy end
        response_data = Hash.new
        response_data[:type] = 'start_discuss'
        response_data[:data] = second
        DiscussCountDownJob.set(wait: second.second).perform_later thought
        ActionCable.server.broadcast "meeting_#{thought.meeting_id}", response_data
      end
    end
  end

  def send_opinion(data)
    ThoughtOpinion.create!({thought_id: data['id'], user_id: current_user[:um].user_id, opinion: data['opinion'].to_i})
  end

  def change_discuss_thought(data)
    if t_id = data['id'].to_i
      if now_thought = Thought.find(t_id)
        now_thought.update!({discussing: 3})
        if status = data['status'].to_i
          thoughts_ids = Thought.where({meeting_id: current_user[:um].meeting_id, discussing: 0, ttype: status}).ids
          most_picked_ids = ThoughtPick.where(thought_id: thoughts_ids).group('thought_id').order('count_user_id desc').count('user_id').first
          if most_picked_ids && most_picked_ids.length > 0
            response_data = Hash.new
            response_data[:type] = 'change_discuss_thought'
            response_data[:data] = Hash.new
            response_data[:data][:thought] = Hash.new
            d_thought = Thought.find(most_picked_ids[0])
            d_thought.update!({discussing: 1})
            response_data[:data][:thought][:thought] = d_thought
            response_data[:data][:thought][:user] = d_thought.user
            ActionCable.server.broadcast "meeting_#{d_thought.meeting_id}", response_data
          end
        end
      end
    end
  end

  def end_discuss()
    meeting = current_user[:um].meeting
    meeting.update!({status: 8})
    meeting.thoughts.each do |thought|
      thought.update!({discussing: 3})
    end
    response_data = Hash.new
    response_data[:type] = 'end'
    ActionCable.server.broadcast "meeting_#{meeting.id}", response_data
  end
end
