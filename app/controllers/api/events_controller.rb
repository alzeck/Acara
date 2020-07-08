class Api::EventsController < ApplicationController
  skip_before_action :verify_authenticity_token

  #GET su /api/events
  def index
    if params.has_key?(:apiKey) && !getUserBySK(params[:apiKey]).nil?
        @event = Event.all
        render json: @event.as_json(methods: %i[going interested organizer tags])
    else
      render body: nil, status: 401
    end
  end

  #GET su /api/events/:id
  def show
    if params.has_key?(:apiKey) && !getUserBySK(params[:apiKey]).nil?
      id = params[:id]

      if Event.exists?(id)
        @event = Event.find(id)
        render json: @event.as_json(methods: %i[going interested tags organizer comments])
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
      if helpers.hasAll(params[:event])
        par = params[:event].permit(:where, :cords, :start, :end, :title,
          :description, :tags)

        tags = helpers.createTags(par[:tags])

        @event = Event.new(where: par[:where], cords: par[:cords], start: par[:start],
                            end: par[:end], title: par[:title], description: par[:description], user: current_user)

        if @event.valid?
          if @event.save
            helpers.createHasTags(tags, @event)
            render json: @event.as_json(methods: %i[going interested tags organizer comments])
          else
            render body: nil, status: 500
          end
        else
          render body: nil, status: 400
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

          if helpers.hasAll(params[:event])
            par = params[:event].permit(:where, :cords, :start, :end, :title,
              :description, :tags)

            @event.assign_attributes(where: par[:where], cords: par[:cords], start: par[:start],
              end: par[:end], title: par[:title], description: par[:description], modified: true)

            if @event.valid?
              if @event.save
                helpers.destroyHasTags(@event)
                tags = helpers.createTags(par[:tags])
                helpers.createHasTags(tags, @event)

                render json: @event.as_json(methods: %i[going interested tags organizer comments])
              else
                render body: nil, status: 500
              end
            else
              render body: nil, status: 400
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
