class Group < ActiveRecord::Base
  attr_accessible :name, :parent_group_id, :user_ids, as: :admin

  validates :name, presence: true, uniqueness: true
  validates :parent_group_id, presence: true

  belongs_to :parent_group
  has_many :memberships
  has_many :users, through: :memberships

  def to_s
    name
  end
end
