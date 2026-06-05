class UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc)
  end

  def index
    @current = current_user
    @friends = current_user.friends + current_user.friends_received
    @others = User.where.not(id: [@current.id] + @friends.map(&:id))
    @pending_sent = current_user.sent_requests.pluck(:receiver_id)
  end
end
