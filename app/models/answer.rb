class Answer < ActiveRecord::Base

  attr_accessible :result, as: :user

  validates :user_id, :result, presence: true

  belongs_to :user

end