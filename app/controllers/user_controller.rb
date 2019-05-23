require 'uuidtools'

class UserController < ApplicationController
  def new
    if session[:user_id]
      redirect_to meeting_index_path
    end
    @user = User.new
  end

  def show
  end

  def create
    if User.exists?(skey: user_params[:name])
      user = User.find_by(skey: user_params[:name])
      session[:user_id] = user.id
    else
      user = User.new
      user.name = user_params[:name]
      user.skey = UUIDTools::UUID.timestamp_create.to_s
      user.save
      session[:user_id] = user.id
    end
    redirect_to meeting_index_path
  end

  private
  def user_params
    params.require(:user).permit(:name)
  end
end
