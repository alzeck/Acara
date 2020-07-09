Trestle.resource(:comments) do
  menu do
    item :comments, icon: "fa fa-comment"
  end

  table do
    column :id, link: true
    column :user, header: "Author"
    column :event
    column :content
    column :previous
    column :created_at
    column :updated_at

    actions do |a|
      a.delete
    end
  end
  
  form do |comment|
    username = (comment.user.present? && User.find(comment.user.id)) ? User.find(comment.user.id).username : ""
    static_field :user, username
    eventname = (comment.event.present? && Event.find(comment.event.id)) ? Event.find(comment.event.id).title : ""
    static_field :event, eventname
    text_area :content
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:comment).permit(:name, ...)
  # end
end
