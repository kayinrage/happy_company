class Chart  < ActiveRecord::Base

  def self.columns
    @columns ||= []
  end

end