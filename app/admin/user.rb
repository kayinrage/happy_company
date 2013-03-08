ActiveAdmin.register User do
  menu :priority => 2
  config.batch_actions = false

  index do
    column :email
    column :first_name
    column :last_name
    column "Group", :sortable => false do |user|
      user.groups.map(&:name).sort*", "
    end
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    default_actions
  end

  filter :email
  filter :first_name
  filter :last_name

  form do |f|
    f.inputs "User Details" do
      f.input :email
      f.input :first_name
      f.input :last_name
      if f.object.new_record?
        f.input :password
        f.input :password_confirmation
      else
        f.input :groups, :as => :check_boxes, :collection => Group.order(:name)
      end
    end
    f.actions
  end


end