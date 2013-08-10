ActiveAdmin.register User do
  menu priority: 2
  config.batch_actions = false
  actions :all, except: :show

  index do
    column :email
    column :first_name
    column :last_name
    column "Group", sortable: false do |user|
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

  form partial: "form"

end