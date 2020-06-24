class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  def show
    current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
      user = User.find(params[:id])
      events = Event.where(user_id: params[:id])
      @user_json = {
        username: user.username,
        verification: user.verification,
        followers: user.followers,
        following: user.following,
        events: events,
      }
      render json: @user_json
    else
      render body: nil, status: 401
    end
  end
end
