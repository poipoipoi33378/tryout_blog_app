class EntriesController < ApplicationController
  before_action :set_entry,only: [:destroy,:edit,:update]
  before_action :set_blog,only: [:new,:create,:edit]

  def destroy
    blog = @entry.blog
    @entry.destroy
    flash[:success] = "Entry deleted"
    redirect_to blog_path(blog)
  end

  def new
    @entry = @blog.entries.build
  end

  def create
    @entry = @blog.entries.build(entry_params)

    if @entry.save
      flash[:success] = "Entry created"
      redirect_to blog_path(@blog)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @entry.update(entry_params)
      redirect_to blog_path(@entry.blog)
    else
      render :edit
    end
  end

  private
    def set_entry
      @entry = Entry.find(params[:id])
    end

    def set_blog
      @blog = Blog.find(params[:blog_id])
    end

    def entry_params
      params.require(:entry).permit(:title,:body)
    end

  end
