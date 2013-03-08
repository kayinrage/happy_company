class Answer < ActiveRecord::Base

  attr_accessible :result, as: :user
  attr_accessible :date, :result

  validates :user_id, :result, :date, presence: true
  validates :date, uniqueness: true
  validates :result, numericality: {only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 3}

  belongs_to :user

end