class Api::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token

  #GET su /api/users/ 
  def index
    if params.has_key?(:apiKey) && !getUserBySK(params[:apiKey]).nil?
      @user = User.all
      render json: @user.as_json(methods: %i[following followers followingTags])
    else
      render body: nil, status: 401
    end
  end
 
  #GET su /api/users/:id
  def show
    if params.has_key?(:apiKey) && !getUserBySK(params[:apiKey]).nil?
      if User.exists?(params[:id])
		  @user = User.find(params[:id])
		  events = Event.where(user_id: params[:id])
		  
		  render json: @user.as_json(methods: %i[following followers followingTags]).merge(events: events.as_json)
      else
      	  render body: nil, status: 404
      end
    else
      render body: nil, status: 401
    end
  end
end
