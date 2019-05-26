module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user
    
    def connect
      self.current_user = find_verified_user
    end

    private
      def find_verified_user

        active_um_id = cookies.signed[:active_um]
        if um = UserMeetingRelationship.find(active_um_id)
        else
          reject_unauthorized_connection
        end

        if user = User.find_by(id: request.session[:user_id])
          if user.id == um.user_id
            current_user = Hash.new()
            current_user[:user] = user
            current_user[:um] = um
            current_user
          else
            reject_unauthorized_connection
          end
        else
          reject_unauthorized_connection
        end
      end
    
  end
end
