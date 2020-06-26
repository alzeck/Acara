Trestle.resource(:users) do
  menu do
    item :users, icon: "fa fa-star"
  end

  table do
    column :id, link: true
    column :username
    column :email
    column :position
    column :bio
    column :verification
    column :admin
    column :mailflag
    column :created_at
    column :updated_at

    actions do |a|
      a.delete unless a.instance == current_user
    end
  end
  
  form do |user|
    text_field :username
    email_field :email
    text_area :bio
    check_box :verification
    check_box :admin
    check_box :mailflag
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:user).permit(:name, ...)
  # end
end
