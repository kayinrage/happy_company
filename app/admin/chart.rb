ActiveAdmin.register Chart do
  config.comments = false
  before_filter do @skip_sidebar = true end
  config.clear_action_items!

  controller do
    def index
      # some hopefully useful code
      render 'admin/charts/index', :layout => 'active_admin'
    end
  end
end                                   
