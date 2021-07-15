class Authenticated::DashboardController < Authenticated::BaseController
  def show
    @user = current_user
    @friend_list = @user.friendships.map do |friend|
      User.find(friend.friend_id)
    end
  end
end
