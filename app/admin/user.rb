ActiveAdmin.register User do
  menu priority: 2
  config.batch_actions = false
  actions :all, except: :show

  permit_params :name, :first_name, :last_name, :password, :password_confirmation, group_ids: []

  index do
    column :email
    column :first_name
    column :last_name
    column 'Group', sortable: false do |user|
      user.groups.map(&:name).sort.join(', ')
    end
    column :current_sign_in_at
    column :last_sign_in_at
    column :sign_in_count
    actions
  end

  filter :email
  filter :first_name
  filter :last_name
  filter :groups

  form partial: 'form'
end
