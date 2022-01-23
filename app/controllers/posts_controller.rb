class PostsController < ApplicationController
    before_action :require_signed_in!, except: [:show]
    before_action :require_user_owns_post!, only: [:edit, :update]
    before_action :index
    
    def index 
      @q = Sub.ransack(params[:q])
      @subs = @q.result
  end
  
    def new
      @post = Post.new
    end
  
    def create
      @post = current_user.posts.new(post_params)
      if @post.save
        redirect_to post_url(@post)
      else
        flash.now[:errors] = @post.errors.full_messages
      end
    end
  
    def show
      @post = Post.find(params[:id])
      # binding.pry
      @sub = Sub.find_by(slug: @post.subs.first.slug)
    end
  
    def edit
      @post = Post.find(params[:id])
    end
  
    def update
      @post = Post.find(params[:id])
      if @post.update(post_params)
        redirect_to post_url(@post)
      else
        flash.now[:errors] = @post.errors.full_messages
        render :edit
      end
    end
  
    def downvote
      vote(-1)
    end
  
    def upvote
      vote(1)
    end
  
    private
    def post_params
      params.require(:post).permit(
      :url, :title, :content, :user_id, sub_ids: []
      )
    end
  
    def require_user_owns_post!
      return if current_user.posts.find_by(id: params[:id])
      render json: 'Forbidden', status: :forbidden
    end
  
    def vote(direction)
      @post = Post.find(params[:id])
      @user_vote = @post.user_votes.find_or_initialize_by(user: current_user)
  
      unless @user_vote.update(value: direction)
        flash[:errors] = @user_vote.errors.full_messages
      end
  
      redirect_to post_url(@post)
    end
end
  