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
        data_table = GoogleVisualr::DataTable.new
        data_table.new_column('string', 'Day')

        users = User.where(id: @p[:user_ids])
        users.each { |user| data_table.new_column('number', user.display_name) }

        result = []
        (Date.today-(@p[:time] == "week" ? 7 : 29).days..Date.today-1).map do |date|
          row = [date.to_s]
          users.each do |user|
            row << (user.answers.where(date: date).first.result rescue -1)
          end
          result << row
        end

        data_table.add_rows(result)

        option = {height: 400, title: 'Your last 30 days', vAxis: {viewWindow: {min: 0, max: 3}, :format => "#", gridlines: {count: 4}}}
        @chart = GoogleVisualr::Interactive::LineChart.new(data_table, option)
      elsif params[:commit] == "Generate"
        flash[:error] = "You have to choose some users / groups if you want to generate chart"
      end
      render 'admin/charts/index', :layout => 'active_admin'
    end
  end
end                                   
