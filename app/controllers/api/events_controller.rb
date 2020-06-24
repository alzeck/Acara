class Api::EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  #GET su /api/events/:id
  def show
    current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
      id = params[:id]

      if Event.exists?(id)
        @event = Event.find(id)
        #get its partecipation info
        #@part = Participation.where(user_id: current_user.id, event_id: id)[0]

        render json: @event
      else
        render body: nil, status: 404
      end
    else
      render body: nil, status: 401
    end
  end

  #POST su /api/events
  def create
    current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
      par = params[:event].permit(:where, :cords, :start, :end, :title,
                                  :description, :cover, :tags)

      tags = helpers.createTags(par[:tags])

      @event = Event.new(where: par[:where], cords: par[:cords], start: par[:start],
                         end: par[:end], title: par[:title], description: par[:description],
                         cover: par[:cover], user: current_user)

      if @event.valid?
        if @event.save
          helpers.createHasTags(tags, @event)
          render json: @event
        else
          render body: nil, status: 500
        end
      else
        render body: nil, status: 400
      end
    else
      render body: nil, status: 403
    end
  end

  #PUT o PATCH su /api/events/:id
  def update
    current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
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
              render json: @event
            else
              render body: nil, status: 500
            end
          else
            render body: nil, status: 400
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

  #DELETE su /api/events/:id
  def destroy
    current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
      id = params[:id]

      if Event.exists?(id)
        event = Event.find(id)

        if current_user.id == event.user_id || current_user.admin
          event.cover.purge_later

          if event.destroy
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
