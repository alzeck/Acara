class Api::ParticipationsController < ApplicationController

  #POST su /api/events/:event_id/participations
  def create
    if user_signed_in?
      event_id = params[:event_id]
      par = params[:participation].permit(:value)
      if Event.exists?(event_id)
        participation = Participation.new(value: par[:value], user_id: current_user.id,
                                          event_id: event_id)

        if participation.valid?
          if participation.save!
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

  #PATCH/PUT su /api/events/:event_id/participations/:id
  def update
    if user_signed_in?
      event_id = params[:event_id].to_i
      participation = Participation.where(id: params[:id])[0]

      if !participation.nil? && participation.event_id == event_id
        # check if the participation exists for the given event
        # if it exists the event that contains it exists
        if current_user.id == participation.user_id || current_user.admin
          par = params[:participation].permit(:value)
          participation.assign_attributes(value: par[:value])
          if participation.valid?
            if participation.save
              render status: 200
            else
              render status: 500
            end
          else
            render status: 400
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

  #DELETE su /api/events/:event_id/participations/:id
  def destroy
    if user_signed_in?
      event_id = params[:event_id].to_i
      participation = Participation.where(id: params[:id])[0]

      if !participation.nil? && participation.event_id == event_id
        # check if the participation exists for the given event
        # if it exists the event that contains it exists
        if current_user.id == participation.user_id || current_user.admin
          if participation.destroy
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
