class ParentGroup < ActiveRecord::Base
  has_many :groups
  has_many :memberships, through: :groups
  has_many :users, through: :memberships

  validates :name, presence: true, uniqueness: true

  before_destroy :protect_if_has_group

  private

  def protect_if_has_group
    groups.count == 0
  end

  public

  def self.for_select
    all.map { |parent_group| [parent_group.name, parent_group.id] }
  end

  def to_s
    name
  end
end
