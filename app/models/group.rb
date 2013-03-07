class Group < ActiveRecord::Base

  attr_accessible :name, :parent_group_id, as: :admin

  belongs_to :parent_group
  has_many :memberships
  has_many :users, through: :memberships

end