class PostsController < ApplicationController

  def new
    @new_post = Post.new
  end

  def create
    @post = Post.create params[:post].permit(:title, :content, :image)
    @post.save ? redirect_to(post_path(@post)) : render('new')
  end

  def index
    @posts = Post.by_tag_or_all(params[:tag_id])
    @new_post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    @post.update params[:post].permit(:drawing)

    WebsocketRails[:drawing].trigger 'update_drawing', {id: @post.id, drawing: @post.drawing_updated_at, image_url: @post.drawing.url}
    
    redirect_to ('/')
  end

  def destroy
  end

  def show
    @post = Post.find_by(params[:post_id])
    @post_for_comment = Post.find_by(params[:post_id])
    @new_comment = Comment.new
  end

end
