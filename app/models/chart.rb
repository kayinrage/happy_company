class Chart < ActiveRecord::Base

  def self.columns
    @columns ||= []
  end

  def self.params_processing(params)
    result = {type: params["type"] ? params["type"] : "users", time: params["time"] ? params["time"] : "month", group_ids: [], user_ids: [], parent_group_ids: []}
    if params["type"] == "users"
      result[:user_ids] = params["user_ids"].blank? ? [] : params["user_ids"]
    elsif params["type"] == "groups"
      result[:group_ids] = params["group_ids"].blank? ? [] : params["group_ids"]
      result[:parent_group_ids] = params["parent_group_ids"].blank? ? [] : params["parent_group_ids"]
    end
    result
  end

end