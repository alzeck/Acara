class TagsController < ApplicationController

  #POST su /tags
  def create
    if user_signed_in?
      tag_id = params[:follows_tag].permit(:tag_id)[:tag_id]
      if Tag.exists?(tag_id)
        tag = Tag.find(tag_id)
        follows_tag = FollowsTag.new(user_id: current_user.id, tag_id: tag_id)
        if follows_tag.valid?
          if follows_tag.save
            redirect_to "/search?q=%23#{tag.name[1..]}"
            #redirect_to root_path
          else
            render_500
          end
        else
          render_400
        end
      else
        render_404
      end
    else
      render_401
    end
  end
  

  #DELETE su /tags/:id
  def destroy
    if user_signed_in?
      if FollowsTag.exists?( params[:id] )
        follows_tag = FollowsTag.find( params[:id] )

        if current_user.id == follows_tag.user_id || current_user.admin
          if follows_tag.destroy
            redirect_to root_path
          else
            render_500
          end
        else
          render_403
        end
      else
        render_404
      end
    else
      render_401
    end
  end

end
