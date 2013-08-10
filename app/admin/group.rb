ActiveAdmin.register Group do
  menu priority: 4
  config.batch_actions = false
  actions :all, except: :show

  index do
    column :name
    column "Parent group", sortable: false do |group|
      group.parent_group.name
    end
    default_actions
  end

  filter :name
  filter :parent_group

  form do |f|
    f.inputs "Parent Group Details" do
      f.input :name
      if f.object.new_record?
        f.input :parent_group_id, as: :select, collection: ParentGroup.for_select, include_blank: false
      else
        f.input :parent_group_id, as: :select, collection: ParentGroup.for_select, include_blank: false
        f.input :users, as: :check_boxes, collection: User.order(:email)
      end
    end
    f.actions
  end
end