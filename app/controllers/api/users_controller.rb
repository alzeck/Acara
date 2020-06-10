class Api::UsersController < ApplicationController
  def show
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
  end
end
