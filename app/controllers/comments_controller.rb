class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_back fallback_location: posts_path, notice: "Comment added successfully."
    else
      redirect_back fallback_location: posts_path, alert: "Comment can't be blank."
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if @comment.user == current_user
    redirect_back fallback_location: posts_path
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end