class CommentsController < ApplicationController
  before_action :set_comment,only: [:destroy,:edit]
  before_action :set_entry,only: [:create]

  def destroy
    @comment.destroy
    flash[:success] = "Comment deleted"
    redirect_to blog_entry_path(@comment.entry.blog,@comment.entry)
  end

  def create
    @comment = @entry.comments.build(comment_params)
    @blog = @entry.blog

    if @comment.save
      redirect_to blog_entry_path(@blog,@entry)
    else
      @entry.comments.delete(@comment)
      render 'entries/show'
    end
  end

  def edit
    @comment.approved = true
    @comment.save
    redirect_to blog_entry_path(@comment.entry.blog,@comment.entry)
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
