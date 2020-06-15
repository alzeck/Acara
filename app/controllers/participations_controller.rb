class ParticipationsController < ApplicationController

  #GET su /events/:event_id/participations
  def index
    event_id = params[:event_id]

    if Event.exists?(event_id)
      if user_signed_in?
        part = Participation.where(user_id: current_user.id, event_id: event_id)[0]

        if part.nil?
          @participation = nil
        else
          @participation = part.value
        end
      else
        @participation = nil
      end
    else
      render_404
    end
  end

  #POST su /events/:event_id/participations
  def create
    if user_signed_in?
      event_id = params[:event_id]
      value = params[:participation].permit(:value)
      if Event.exists?(event_id)
        participation = Participation.new(value: value, user_id: current_user.id,
                                          event_id: event_id)

        if participation.valid?
          if participation.save
            redirect_to event_path(Event.find(event_id))
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

  #PATCH/PUT su /events/:event_id/participations/:id
  def update
    if user_signed_in?
      event_id = params[:event_id]
      participation = Participation.find(id: params[:id])
      if !participation.nil? && participation.event_id == event_id
        # check if the participation exists for the given event
        # if it exists the event that contains it exists
        if current_user.id == participation.user_id || current_user.admin
          value = params[:participation].permit(:value)
          participation.assign_attributes(value: value)
          if participation.valid?
            if participation.save
              redirect_to event_path(event)
            else
              render_500
            end
          else
            render_400
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

  #DELETE su /events/:event_id/participations/:id
  def destroy
    if user_signed_in?
      event_id = params[:event_id]
      participation = Participation.find(id: params[:id])
      if !participation.nil? && participation.event_id == event_id
        # check if the participation exists for the given event
        # if it exists the event that contains it exists
        if current_user.id == participation.user_id || current_user.admin
          if participation.destroy
            redirect_to event_path(Event.find(event_id))
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
