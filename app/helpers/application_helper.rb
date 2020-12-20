module ApplicationHelper
    def full_title(page_title="")
        base_title = "PhotoTime"
        if !page_title.empty?
            page_title + " | " + base_title
        else
            base_title
        end
    end

    # ??????????????
    # def aaa(post)
    #     # post.user.posts.ids.each do |i|
    #       return post.user.posts.ids[1]
    #     # end
    # end

    def characters_limit(post)
        if post && post.content.length <= 10
            return post.content
        elsif post && post.content.length > 10
            return post.content[0,10] + "..."
        else !post
            return "投稿はありません"
        end
    end

    def username_limit(name)
        if name && name.length <= 8
            return name
        else name && name.length > 8
            return name[0,8] + "…"
        end
    end

    def introduce_limit(introduce)
        if introduce && introduce.length <= 25
            return introduce
        else introduce && introduce.length > 25
            return introduce[0,25] + "…"
        end
    end

    def text_limit(text)
        if text && text.length <= 30
            return text
        else text && text.length > 30
            return text[0, 30] + "…"
        end
    end

    # def url1
    #     @user = User.find_by(id: params[:id])
    #     request.request_uri == user_path(@user)
    # end

    # def aaa?
    #     @user = User.find_by(id: params[:id])
    #     debugger
    #     return "https://localhost:3000/users/#{@user.id}" == request.url
    # end

    # def url2
    #     url_for controller: 'pages', action: 'show', only_path: false
    # end

end
