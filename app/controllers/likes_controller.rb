class LikesController < ApplicationController
    def create
        @like = current_user.likes.build(post_id: params[:post_id])
        @post = @like.post
        @like.save
        post = Post.find(params[:post_id])
        post.create_notification_like!(current_user)
        redirect_back(fallback_location: root_path)
    end

    def destroy
        @like = Like.find_by(post_id: params[:post_id], user_id: current_user.id)
        @like.destroy
        redirect_back(fallback_location: root_path)
    end
end
