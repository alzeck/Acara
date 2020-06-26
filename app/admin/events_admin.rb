Trestle.resource(:events) do
  menu do
    item :events, icon: "fa fa-star"
  end

  table do
    column :id, link: true
    column :user, header: "Author"
    column :title
    column :description
    column :start
    column :end
    column :where
    column :cords, header: "Coords"
    column :modified
  end
  
  form do |event|
    text_field :title
    text_area :description
    # datetime_field :start
    # datetime_field :end
    # text_field :where
    # text_field :cords
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:event).permit(:name, ...)
  # end
end
