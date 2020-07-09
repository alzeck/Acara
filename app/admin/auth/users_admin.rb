Trestle.resource(:users, model: (defined? User) ? User.where(admin: true) : User , scope: Auth) do
  menu do
    group :configuration, priority: :last do
      item :users, icon: "fa fa-shield", label: "Admins"
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

  form do |administrator|
    static_field :username
    static_field :email

    check_box :verification
    check_box :admin
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
