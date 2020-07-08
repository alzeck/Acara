class Api::CommentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  #GET /api/events/:event_id/comments
  def index
    current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
      id = params[:event_id]

      if Event.exists?(id)
        @comments = Event.find(id).comments
        render json: @comments
      else
        render body: nil, status: 404
      end
    else
      render body: nil, status: 401
    end
  end

  #GET /api/events/:event_id/comments/:id
  def show
    current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
      event_id = params[:event_id]
      id = params[:id]

      if Event.exists?(event_id) && Comment.exists?(id)
				@comment = Comment.find(id)
				if @comment.event_id == event_id.to_i
					render json: @comment.as_json
				else
					render body: nil, status: 400
				end
      else
        render body: nil, status: 404
      end
    else
      render body: nil, status: 401
    end
  end

  #POST su /api/events/:event_id/comments
  def create
    current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
      event_id = params[:event_id]
      
      if Event.exists?(event_id)
        par = params[:comment].permit(:content, :previous_id)

        comment = Comment.new(content: par[:content], previous_id: par[:previous_id],
                              user_id: current_user.id, event_id: event_id)

        if comment.valid?
          if comment.save
            render json: comment.as_json
          else
            render body: nil, status: 500
          end
        else
          render body: nil, status: 400
        end
      else
        render body: nil, status: 404
      end
    else
      render body: nil, status: 401
    end
  end

  #PATCH/PUT su /api/events/:event_id/comments/:id
  def update
    current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
      event_id = params[:event_id].to_i
      comment = Comment.where(id: params[:id])[0]

      if !comment.nil? && comment.event_id == event_id
        # check if the comment exist inside the event
        # a comment can only exists if the event that contains it exists
        if current_user.id == comment.user_id || current_user.admin
          # check if the user is autorized to change the comment
          content = params[:comment].permit(:content)[:content]
          comment.assign_attributes(content: content)
          if comment.valid?
            #check the validity of the comments
            if comment.save
              render json: comment.as_json
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

  #DELETE su /api/events/:event_id/comments/:id
  def destroy
    current_user = getUserBySK(params[:apiKey])
    if !current_user.nil? && params.has_key?(:apiKey)
      event_id = params[:event_id].to_i
      comment = Comment.where(id: params[:id])[0]

      if !comment.nil? && comment.event_id == event_id
        # check if the comment exist inside the event
        # a comment can only exists if the event that contains it exists
        if current_user.id == comment.user_id || current_user.admin
          # check if the user is autorized to change the comment

          if comment.destroy
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
