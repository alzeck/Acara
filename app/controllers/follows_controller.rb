class FollowsController < ApplicationController

  #GET su /users/:user_id/follows
  def index
    @followers = Follow.where(followed_id: params[:user_id])
    @following = Follow.where(follower_id: params[:user_id])
    @tags = FollowsTag.where(user_id: params[:user_id])
  end


  #POST su /users/:user_id/follows
  def create
    if user_signed_in?
      if User.exists?( params[:user_id] )
        followed_id = params[:user_id]
        follow = Follow.new(followed_id: followed_id, follower_id: current_user.id)
  
        if follow.valid?
          if follow.save
            redirect_to user_path(User.find(followed_id))
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
  

  #DELETE su /users/:user_id/follows/:id
  def destroy
    if user_signed_in?
      if User.exists?( params[:user_id] ) && Follow.exists?( params[:id] )
        user = User.find(params[:user_id])
        follow = Follow.find(params[:id])

        if current_user.id == follow.follower_id || current_user.admin
          if follow.destroy
            redirect_to user_path(user)
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
