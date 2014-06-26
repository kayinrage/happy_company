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
    f.inputs 'Parent Group Details' do
      f.input :name
    end
    f.actions
  end

  controller do
    def destroy
      @parent_group = ParentGroup.find(params[:id])
      if @parent_group.destroy
        redirect_to admin_parent_groups_path, notice: 'Parent group was successfully destroyed.'
      else
        redirect_to admin_parent_groups_path, alert: 'Parent group cannot be destroyed because it has attached group.'
      end
    end
  end
end
