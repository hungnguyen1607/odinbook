class CommentsController < ApplicationController
  before_action :authenticate_user!
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to post_path(@post), notice: "Comment added successfully."
    else
      redirect_to post_path(@post), alert: "Failed to add comment."
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if @comment.user == current_user
    redirect_to Post.find(params[:post_id])
  end

  private
  def comment_params
    params.require(:comment).permit(:body)          
  end
end
