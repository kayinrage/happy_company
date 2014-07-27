class Chart < ActiveRecord::Base
  WEEK_DAYS = 8
  MONTH_DAYS = 31

  def self.columns
    @columns ||= []
  end

  def self.params_processing(params)
    result = {type: params['type'] ? params['type'] : 'users', time: params['time'] ? params['time'] : 'month', group_ids: [], user_ids: [], parent_group_ids: []}
    if params['type'] == 'users'
      result[:user_ids] = params['user_ids'].blank? ? [] : params['user_ids']
    elsif params['type'] == 'groups'
      result[:group_ids] = params['group_ids'].blank? ? [] : params['group_ids']
      result[:parent_group_ids] = params['parent_group_ids'].blank? ? [] : params['parent_group_ids']
    end
    result
  end

  def self.for_current_user(user)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Day')
    data_table.new_column('number', 'Happiness', (0..3))
    data_table.add_rows(user.answers.limit(30).order('date desc').reverse.map { |a| [a.date.to_s, a.result] })
    option = {height: 400, colors: ['#00b0bc'], backgroundColor: '#fcffff', title: 'Your last 30 days', vAxis: {viewWindow: {min: 0, max: 3}, format: '#', gridlines: {count: 4}}}
    GoogleVisualr::Interactive::AreaChart.new(data_table, option)
  end

  def self.for_admin(params)
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Day')
    data_table = data_table_for_admin_chart(data_table, params)
    option = {height: 400, title: "Last #{number_of_days(params)-1} days", vAxis: {viewWindow: {min: 0, max: 3}, format: '#', gridlines: {count: 4}}}
    GoogleVisualr::Interactive::LineChart.new(data_table, option)
  end

  private

  def self.data_table_for_admin_chart(data_table, params)
    object_name = params[:type].singularize
    objects = object_name.capitalize.constantize.where(id: params["#{object_name}_ids"])
    objects.each { |o| data_table.new_column('number', o.name) }
    result = send("result_for_#{params[:type]}", objects, params)
    data_table.add_rows(result)
    data_table
  end

  def self.result_for_users(objects, params)
    result = []
    days_for_iteration(params).map do |date|
      row = [date.to_s]
      objects.each { |user| row << (user.answers.where(date: date).first.result rescue -1) }
      result << row
    end
    result
  end

  def self.result_for_groups(objects, params)
    result = []
    days_for_iteration(params).map do |date|
      row = [date.to_s]
      objects.each do |group|
        group_avg = []
        group.users.each { |user| group_avg << (user.answers.where(date: date).first.result rescue nil) }
        group_avg.compact!
        row << (group_avg.blank? ? -1 : group_avg.sum * 1.0 / group_avg.size).round(2)
      end
      result << row
    end
    result
  end

  def self.number_of_days(params)
    params[:time] == 'week' ? WEEK_DAYS : MONTH_DAYS
  end

  def self.days_for_iteration(params)
    Date.today-(number_of_days(params)).days..Date.today-1
  end
end
