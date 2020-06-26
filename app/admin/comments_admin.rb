Trestle.resource(:comments) do
  menu do
    item :comments, icon: "fa fa-star"
  end

  table do
    column :id, link: true
    column :user, header: "Author"
    column :event
    column :content
    column :previous
    column :created_at
    column :updated_at
  end
  
  form do |comment|
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
