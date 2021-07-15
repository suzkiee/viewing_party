class FriendshipsController < ApplicationController
  def create
    friend = User.find_by(email: friend_params[:email])
    if friend.present?
      if current_user.friends_emails.include?(friend.email) || friend.email == current_user.email
        flash[:error] = "Unable to Add User"
      else
        new_friend = Friendship.new(user_id: current_user.id, friend_id: friend.id)
        new_friend.save
        flash[:success] = "#{friend.email[/[^@]+/]} Added as Friend"
      end
    else
      flash[:error] = 'User not found'
    end
    redirect_to dashboard_path
  end

  private
    def friend_params
      params.permit(:email)
    end
end
