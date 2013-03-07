class Answer < ActiveRecord::Base
  attr_accessible :result, as: :user
  belongs_to :user
end