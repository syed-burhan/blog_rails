class PostsController < ApplicationController
	caches_page :new
	caches_action :index		#, expires_in: 1.hour

	before_action :find_post, only: [:show, :update, :edit, :destroy]
  
	def index
		@posts = Post.all.order("created_at DESC")
	end

	def new
		@post = Post.new
	end

	def create
		@post = Post.new(post_params)

		if @post.save
			# Expire the Cache Manually
			expire_action(controller: 'posts', action: 'index')
			redirect_to @post
		else
			render 'new'
		end
	end

	def show
	end

	def update

		if @post.update(post_params)
			expire_action(controller: 'posts', action: 'index')
			redirect_to @post
		else
			render 'edit'
		end
	end

	def edit
		@post = Post.find(params[:id])
	end

	def destroy
		@post.destroy
		# expire_action(controller: 'posts', action: 'index')

		redirect_to posts_path
	end

	def search
		@search_keyword = params[:search_keyword]

		if @search_keyword.present?
		  @posts = Post.where("title LIKE ?", "%#{@search_keyword}%")
		else
		  @posts = Post.all
		end
		@posts = @posts.order("created_at DESC")
	end

	private

	def post_params
		params.require(:post).permit(:title, :content)
	end

  def find_post
    @post = Post.find(params[:id])
  end
end
