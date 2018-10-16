class BlogsController < ApplicationController
  before_action :set_blog,only: [:destroy]
  def index
    @blogs = Blog.all
  end

  def destroy
    @blog.destroy
    flash[:success] = "Blog deleted"
    redirect_to blogs_url
  end

  def new
    @blog = Blog.new
  end

  def create
    @blog = Blog.new(blog_params)

    if @blog.save
      flash[:success] = "Blog created"
      redirect_to blogs_url
    else
      render 'new'
    end
  end

  private
    def set_blog
      @blog = Blog.find(params[:id])
    end

    def blog_params
      params.require(:blog).permit(:title)
    end
end
