class BlogsController < ApplicationController
  before_action :set_blog,only: [:destroy,:edit,:update,:show]
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
    @blog = current_user.blogs.build(blog_params)

    if @blog.save
      flash[:success] = "Blog created"
      redirect_to blogs_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @blog.update(blog_params)
      redirect_to blogs_url
    else
      render :edit
    end
  end

  def show
  end

  private
    def set_blog
      @blog = Blog.find(params[:id])
    end

    def blog_params
      params.require(:blog).permit(:title)
    end
end
