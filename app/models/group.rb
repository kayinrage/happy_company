class Group < ActiveRecord::Base
  belongs_to :parent_group
  has_many :memberships
  has_many :users, through: :memberships

  validates :name, presence: true, uniqueness: true
  validates :parent_group_id, presence: true

  def to_s
    name
  end
end
