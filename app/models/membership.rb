class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group

  validates :user_id, :group_id, presence: true
  validates :group_id, uniqueness: {scope: :user_id}
end
