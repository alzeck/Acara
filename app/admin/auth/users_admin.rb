Trestle.resource(:users, model: User, scope: Auth) do
  menu do
    group :configuration, priority: :last do
      item :users, icon: "fa fa-users", label: "Admins"
    end
  end

  table do
    # column :avatar, header: false do |administrator|
    #   avatar_for(administrator)
    # end
    # column :email, link: true
    
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

  #vuoto perchè non ha senso che un admin lo possa modificare
  form do |administrator|
    # text_field :email

    # row do
    #   col(sm: 6) { password_field :password }
    #   col(sm: 6) { password_field :password_confirmation }
    # end
  end

  update_instance do |instance, attrs|
    if attrs[:password].blank?
      attrs.delete(:password)
      attrs.delete(:password_confirmation) if attrs[:password_confirmation].blank?
    end

    instance.assign_attributes(attrs)
  end

  after_action on: :update do
    if Devise.sign_in_after_reset_password && instance == current_user
      login!(instance)
    end
  end
end
