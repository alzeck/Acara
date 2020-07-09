Trestle.resource(:events) do
  menu do
    item :events, icon: "fa fa-calendar"
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

    actions do |a|
      a.delete
    end
  end
  
  form do |event|
    username = ( event.user.present? && User.find(event.user.id)) ? User.find(event.user.id).username : ""
    tags = HasTag.where(event_id: event.id).to_a.map {|elem| elem.tag.name}.join(' ')
    text_field :title
    static_field :user, username
    text_area :description
    static_field :tags, tags
    static_field :start
    static_field :end
    static_field :where
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
