class FlagsController < ApplicationController

  #GET su /flags
  def index
    if user_signed_in?
      if current_user.admin
        @flags = Flag.all
      else
        render_403
      end
    else
      render_401
    end
  end

  #GET su /flags/:id
  def show
    if user_signed_in?
      id = params[:id]

      if Flag.exists?(id)
        if current_user.admin
          @flag = Flag.find(id)
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

  #GET su /flags/new
  # TODO get params and create the url
  # ex GET /flags/new?type=event&id=10
  def new
    if !user_signed_in?
      render_401
    end
  end

  #POST su /flags
  # TODO get params and create the url
  def create
    if user_signed_in?
      par = params[:flag].permit(:reason, :description, :url)
      
      flag = Flag.new(reason: par[:reason], description: par[:description],
                      url: par[:url], user_id: current_user.id)

      if flag.valid?
        if !flag.save
          render_500
        end
      else
        render_400
      end
    else
      render_401
    end
  end

  #DELETE su /flags/:id
  def destroy
    if user_signed_in?
      id = params[:id]

      if Flag.exists?(id)
        flag = Flag.find(id)

        if current_user.admin
          if flag.destroy
            redirect_to flags_path
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
