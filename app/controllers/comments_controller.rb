class CommentsController < ApplicationController
  before_action :set_comment,only: [:destroy,:update]
  before_action :set_entry,only: [:create]

  def destroy
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to entry_path(@comment.entry)
  end

  def create
    @comment = @entry.comments.build(comment_params)
    @blog = @entry.blog

    if @comment.save
      NoticeMailer.sendmail_confirm(@comment).deliver_now
      redirect_to entry_path(@entry)
    else
      @entry.comments.delete(@comment)
      render 'entries/show'
    end
  end

  def update
    @comment.approved = true
    @comment.save
    redirect_to entry_path(@comment.entry)
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_entry
      @entry = Entry.find(params[:entry_id])
    end

    def comment_params
      params.require(:comment).permit(:body)
    end
end
