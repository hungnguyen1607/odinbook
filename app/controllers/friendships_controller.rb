class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  def index
    @pending_requests = current_user.received_requests.where(status: "pending")
  end

  def create
    friendship = current_user.sent_requests.build(receiver_id: params[:receiver_id], status: "pending")
    friendship.save
    redirect_to users_path
  end

  def update
    friendship = Friendship.find(params[:id])
    if friendship.receiver == current_user
      friendship.update(status: "accepted")
    end
      redirect_to friendships_path
  end

  def destroy
    friendship = Friendship.find(params[:id])
    if friendship.requester == current_user || friendship.receiver == current_user
      friendship.destroy
    end
    redirect_to friendships_path
  end
end
