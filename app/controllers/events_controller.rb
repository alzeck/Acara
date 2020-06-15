class EventsController < ApplicationController

  #GET su /events/:id
  def show
    id = params[:id]

    if Event.exists?(id)
      @event = Event.find(id)
      if user_signed_in?
        # get its partecipation info
        @part = Participation.where(user_id: current_user.id, event_id: id)[0]
      end
    else
      render_404
    end
  end

  #GET su /events/new
  def new
    if !user_signed_in?
      render_401
    end
    @event = Event.new
  end

  #POST su /events
  def create
    if user_signed_in?
      par = params[:event].permit(:where, :cords, :start, :end, :title,
                                  :description, :cover, :tags)

      tags = helpers.createTags(par[:tags])

      @event = Event.new(where: par[:where], cords: par[:cords], start: par[:start],
                         end: par[:end], title: par[:title], description: par[:description],
                         cover: par[:cover], user: current_user)

      if @event.valid?
        if @event.save
          helpers.createHasTags(tags, @event)
          redirect_to event_path(@event)
        else
          render_500
        end
      else
        render :new
      end
    else
      render_401
    end
  end

  #GET su /events/:id/edit
  def edit
    if user_signed_in?
      id = params[:id]

      if Event.exists?(id)
        @event = Event.find(id)
        if !(current_user.id == @event.user_id || current_user.admin)
          render_403
        end
      else
        render_404
      end
    else
      render_401
    end
  end

  #PUT o PATCH su /events/:id
  def update
    if user_signed_in?
      id = params[:id]

      if Event.exists?(id)
        @event = Event.find(id)

        if current_user.id == @event.user_id || current_user.admin
          helpers.destroyHasTags(@event)
          par = params[:event].permit(:where, :cords, :start, :end, :title,
                                      :description, :cover, :tags)
          tags = helpers.createTags(par[:tags])

          if par[:cover].nil?
            @event.assign_attributes(where: par[:where], cords: par[:cords], start: par[:start],
                                     end: par[:end], title: par[:title], description: par[:description],
                                     modified: true)
          else
            @event.assign_attributes(where: par[:where], cords: par[:cords], start: par[:start],
                                     end: par[:end], title: par[:title], description: par[:description],
                                     cover: par[:cover], modified: true)
          end

          if @event.valid?
            if @event.save
              helpers.createHasTags(tags, @event)
              redirect_to event_path(@event)
            else
              render_500
            end
          else
            render :edit
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

  #DELETE su /events/:id
  def destroy
    if user_signed_in?
      id = params[:id]

      if Event.exists?(id)
        event = Event.find(id)

        if current_user.id == event.user_id || current_user.admin
          helpers.destroyComments(event)
          helpers.destroyHasTags(event)
          helpers.destroyParticipations(event)

          event.cover.purge_later

          if event.destroy
            redirect_to root_path
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
