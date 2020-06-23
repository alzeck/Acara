class Api::FollowsController < ApplicationController

    #GET su /api/users/:user_id/follows
  def index
    @followers = Follow.where(followed_id: params[:user_id])
    @following = Follow.where(follower_id: params[:user_id])
    @tags = FollowsTag.where(user_id: params[:user_id])
  end


  #POST su /api/users/:user_id/follows
  def create
    if user_signed_in?
      if User.exists?( params[:user_id] )
        followed_id = params[:user_id]
        follow = Follow.new(followed_id: followed_id, follower_id: current_user.id)
  
        if follow.valid?
          if follow.save
            render status: 200
          else
            render status: 500
          end
        else
          render status: 400
        end
      else
        render status: 404
      end
    else
      render status: 401
    end
  end
  

  #DELETE su /api/users/:user_id/follows/:id
  def destroy
    if user_signed_in?
      if User.exists?( params[:user_id] ) && Follow.exists?( params[:id] )
        user = User.find(params[:user_id])
        follow = Follow.find(params[:id])

        if current_user.id == follow.follower_id || current_user.admin
          if follow.destroy
            render status: 200
          else
            render status: 500
          end
        else
          render status: 403
        end
      else
        render status: 404
      end
    else
      render status: 401
    end
  end
end
