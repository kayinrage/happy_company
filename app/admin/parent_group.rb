ActiveAdmin.register ParentGroup do
  menu priority: 3
  config.batch_actions = false
  actions :all, except: :show

  index do
    column :name
    default_actions
  end

  filter :name

  form do |f|
    f.inputs "Parent Group Details" do
      f.input :name
    end
    f.actions
  end
end