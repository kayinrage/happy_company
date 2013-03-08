ActiveAdmin.register Group do
  menu :priority => 4
  config.batch_actions = false

  index do
    column :name
    column "Parent group", :sortable => false do |group|
      group.parent_group.name
    end
    default_actions
  end

  filter :name
  filter :parent_group

  form do |f|
    f.inputs "Parent Group Details" do
      f.input :name
      f.input :parent_group_id, as: :select, collection: ParentGroup.for_select, include_blank: false
    end
    f.actions
  end
end