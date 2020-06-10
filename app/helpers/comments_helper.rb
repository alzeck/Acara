module CommentsHelper

    #Funzione usata per cancellare tutte le reply del commento
    def destroyReplies(comment)
        replies = Comment.where(previous_id: comment.id)
        for elem in replies
            if ! elem.destroy
                render_500
            end
        end
    end

end
