class UsersController < ApplicationController
  def show
    id = params[:id]

    if User.exists?(id)
      @user = User.find(id)
      @events = Event.where(user_id: id)

    else
      render_404
    end
  end
end
