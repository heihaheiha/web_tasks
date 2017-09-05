class PostsController < ApplicationController
  def index
  	exchoice = params[:exchoice]
  	choice = params[:choice]
  	# redirect_to new_post_path(@)
  	if exchoice.eql?("title")
  	  redirect_to post_path(@posts)
  	  @posts = Post.find_all_by_title(choice)
  	elsif exchoice.eql?("author")
  	  @posts = Post.find_all_by_author(choice)
  	elsif exchoice.eql?("date")
  	  @posts = Post.find(choice)
  	else
  	  @posts = Post.all
  	end
  end

  def show
  	@post = Post.find(params[:id])
  end

  def new  
    @post = Post.new 
  end

  def edit
  	@post = Post.find(params[:id])
  end

  def create
  	@post = Post.new(post_params)

  	if @post.save
  	  redirect_to @post
  	else
  	  render 'new'
  	end
  end

  def update
  	@post = Post.find(params[:id])

  	if @post.update(post_params)
  	  redirect_to @post
  	else
  	  render 'edit'
  	end
  end

  private 
    def post_params
      params.require(:post).permit(:title, :author, :text)
    end
end
