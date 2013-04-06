ActiveAdmin.register Chart do
  config.comments = false
  before_filter do @skip_sidebar = true end
  config.clear_action_items!
  actions :index


  controller do
    def index
      @p = Chart.params_processing(params)
      render 'admin/charts/index', :layout => 'active_admin'
    end
  end
end                                   
