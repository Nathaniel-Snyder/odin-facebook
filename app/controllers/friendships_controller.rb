class FriendshipsController < ApplicationController

  def create
    @friendship = current_user.friendships.build(:friend_id => params[:friend_id], 
                                                  accepted: "false")
    if @friendship.save
      flash[:notice] = "Friend requested."
      redirect_to root_url
    else
      flash[:error] = "Unable to request friendship."
      redirect_to root_url
    end
  end

  def update
    @friendship = Friendship.where(friend_id: current_user, user_id: params[:id]).first
    @friendship.update(accepted: true)
    if @friendship.save
      redirect_to user_path(current_user), :notice => "Successfully confirmed friend!"
    else
      redirect_to root_url, :notice => "Sorry! Could not confirm friend!"
    end
  end

  def destroy
    @friendship = Friendship.where(friend_id: [current_user, params[:id]]).
                             where(user_id: [current_user, params[:id]]).last
    @friendship.destroy
    flash[:notice] = "Removed friendship."
    redirect_to user_path(current_user)
  end
end
