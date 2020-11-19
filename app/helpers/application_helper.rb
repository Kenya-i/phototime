module ApplicationHelper
    def full_title(page_title="")
        base_title = "PhotoTime"
        if !page_title.empty?
            page_title + " | " + base_title
        else
            base_title
        end
    end
end
