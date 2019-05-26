require 'uuidtools'

class MeetingController < ApplicationController
  def index
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      redirect_to root_path
    end
  end

  def show
    # if !session[:user_id] || !session[:entering_meeting]
    if !session[:user_id]
      redirect_to root_path
    end
    if Meeting.exists?(id: params[:id])
      @meeting = Meeting.find(params[:id])
      active_um = UserMeetingRelationship.find_by({ user_id: session[:user_id], meeting_id: @meeting.id })
      cookies.signed[:active_um] = active_um.id
      if active_um.active
        EnterMeetingJob.set(wait: 2.second).perform_later active_um
      else
        EnterMeetingJob.perform_later active_um
      end
      session.delete :entering_meeting
    else
      redirect_to meeting_index_path
    end

  end

  def create
    if !session[:user_id]
      redirect_to root_path
    end

    meeting = Meeting.new
    meeting.name = meeting_params[:value]
    meeting.skey = UUIDTools::UUID.timestamp_create.to_s
    meeting.save
    um = UserMeetingRelationship.new
    um.user_id = session[:user_id]
    um.meeting_id = meeting.id
    um.save

    session[:entering_meeting] = meeting.id
    redirect_to meeting_path(meeting)
  end

  def join
    if !session[:user_id]
      redirect_to root_path
    end
    
    if Meeting.exists?(skey: meeting_params[:value])
      meeting = Meeting.find_by(skey: meeting_params[:value])
      
      if !UserMeetingRelationship.exists?({user_id: session[:user_id], meeting_id: meeting.id})
        UserMeetingRelationship.create!({user_id: session[:user_id], meeting_id: meeting.id})
      end

      session[:entering_meeting] = meeting.id
      redirect_to meeting
    else
      redirect_to meeting_index_path
    end

  end

  def enter
    if !session[:user_id]
      redirect_to root_path
    end

    if Meeting.exists?(id: params[:id]) && UserMeetingRelationship.exists?({user_id: session[:user_id], meeting_id: params[:id]})
      meeting = Meeting.find(params[:id])
      session[:entering_meeting] = meeting.id
      redirect_to meeting
    else
      redirect_to meeting_index_path
    end
  end

  private
    def meeting_params
      params.permit(:value)
    end
end
