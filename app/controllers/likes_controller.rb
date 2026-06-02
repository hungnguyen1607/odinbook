class LikesController < ApplicationController
  before_action :authenticate_user!
  def create
    @post = Post.find(params[:post_id])
    unless @post.likes.exists?(user_id: current_user)
      @post.likes.create(user: current_user)
    end
    redirect_to @post
  end

  def destroy
    @post = Post.find(params[:post_id])
    @like = @post.likes.find_by(user_id: current_user)
    @like&.destroy
    redirect_to @post
  end
end
