Trestle.resource(:flags) do
  menu do
    item :flags, icon: "fa fa-star"
  end

  table do
    column :id, link: true
    column :user, header: "Author"
    column :flaggedUser, header: "Flagged User"
    column :flaggedEvent, header: "Flagged Event"
    column :flaggedComment, header: "Flagged Comment"
    column :reason
    column :description
    column :created_at
    column :updated_at
  end

  #vuoto perchè non ha senso che un admin lo possa modificare
  form do |flag|
    # text_field :reason
    # text_area :description
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:flag).permit(:name, ...)
  # end
end
