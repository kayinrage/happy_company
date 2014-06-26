ActiveAdmin.register Chart do
  config.comments = false
  before_filter do
    @skip_sidebar = true
  end
  config.clear_action_items!
  actions :index

  controller do
    def index
      @p = Chart.params_processing(params)
      if !@p[:group_ids].blank? or !@p[:user_ids].blank?
        @chart = Chart.for_admin(params)
      elsif params[:commit] == 'Generate'
        flash[:error] = 'You have to choose some users / groups if you want to generate chart'
      end
      render 'admin/charts/index', layout: 'active_admin'
    end
  end
end                                   
