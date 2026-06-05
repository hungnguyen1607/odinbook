class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :destroy]
  def index
    @posts = Post.where(user_id: [current_user.id, *current_user.friends.pluck(:id)]).order(created_at: :desc)
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to root_path, notice: "Post created successfully."
    else
      render :new
    end
  end

  def destroy
    @post.destroy if @post.user == current_user
    redirect_to posts_path 
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:content, :image)
  end
end
