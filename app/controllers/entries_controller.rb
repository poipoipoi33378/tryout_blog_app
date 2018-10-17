class EntriesController < ApplicationController
  before_action :set_entry,only: [:destroy,:edit,:update,:show]
  def destroy
    blog = @entry.blog
    @entry.destroy
    flash[:success] = "Entry deleted"
    redirect_to blog_path(blog)
  end
  private
    def set_entry
      @entry = Entry.find(params[:id])
    end
end
