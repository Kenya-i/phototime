class CommentsController < ApplicationController
    # before_action :correct_user, only: [:destroy]

    def create
        @post = Post.find(params[:post_id])
        @comment = @post.comments.build(comment_params)
        @comment.user_id = current_user.id
        if @comment.save
            @post.create_notification_comment!(current_user, @comment.id)
            flash[:success] = "Posted successfully!"
            redirect_back(fallback_location: root_path)
        else
            flash[:danger] = "fail to post..."
            redirect_back(fallback_location: root_path)
        end

    end

    def destroy
        @comment = Comment.find_by(id: params[:post_id])
        
        if @comment && @comment.destroy
            @post = @comment.post
            flash[:success] = "Deleted your comment successfully!"
            redirect_to post_url(@post)
        else 
            render "home/top" #すでに削除されている場合
        end

    end


    private
        def comment_params
            params.require(:comment).permit(:content)
        end


        # def correct_user
        #     user_id = User.find_by(id: params[:id])
            
        #     @comment_post_id = Comment.find_by(id: params[:post_id])
        #     if user_id != current_user
        #         redirect_to root_path
        #     end
        # end
end
