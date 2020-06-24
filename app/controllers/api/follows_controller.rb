class Api::FollowsController < ApplicationController
  skip_before_action :verify_authenticity_token

  #GET su /api/users/:user_id/follows
  def index
    @followers = Follow.where(followed_id: params[:user_id])
    @following = Follow.where(follower_id: params[:user_id])
    @tags = FollowsTag.where(user_id: params[:user_id])
  end

  #POST su /api/users/:user_id/follows
  def create
    current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
      if User.exists?(params[:user_id])
        followed_id = params[:user_id]
        follow = Follow.new(followed_id: followed_id, follower_id: current_user.id)

        if follow.valid?
          if follow.save
            render body: nil, status: 200
          else
            render body: nil, status: 500
          end
        else
          render body: nil, status: 400
        end
      else
        render body: nil, status: 404
      end
    else
      render body: nil, status: 401
    end
  end

  #DELETE su /api/users/:user_id/follows/:id
  def destroy
    current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
      if User.exists?(params[:user_id]) && Follow.exists?(params[:id])
        user = User.find(params[:user_id])
        follow = Follow.find(params[:id])

        if current_user.id == follow.follower_id || current_user.admin
          if follow.destroy
            render body: nil, status: 200
          else
            render body: nil, status: 500
          end
        else
          render body: nil, status: 403
        end
      else
        render body: nil, status: 404
      end
    else
      render body: nil, status: 401
    end
  end
end
