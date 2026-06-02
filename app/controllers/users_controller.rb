class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    @posts = @users.posts.order(created_at: :desc)
  end

  def index
    @users = User.where.not(id: current_user.id)
    @pending_sent = current_user.sent_requests.pluck(:receiver_id)
  end
end
