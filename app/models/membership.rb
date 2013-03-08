class Membership < ActiveRecord::Base

  attr_accessible :user_id, :group_id, as: :admin

  validates :user_id, :group_id, presence: true
  validates :group_id, uniqueness: { scope: :user_id }

  belongs_to :user
  belongs_to :group

end