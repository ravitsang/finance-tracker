class FriendshipController < ApplicationController

  def create
    @friend = User.find(params[:friend])
    @friendship = Friendship.create(user_id: current_user.id, friend_id: params[:friend])
    flash[:success] = "You have added #{@friend.full_name} as friend"
    redirect_to my_friends_path
  end

  def destroy
    @friendship = current_user.friendships.where(friend_id: params[:id]).first
    @friendship.destroy
    flash[:success] = "You have deleted the friend"
    redirect_to my_friends_path
  end
end
