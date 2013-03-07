class ParentGroup < ActiveRecord::Base

  attr_accessible :name, as: :admin

  has_many :groups
  has_many :memberships, through: :groups
  has_many :users, through: :memberships

end