class ParentGroup < ActiveRecord::Base
  attr_accessible :name, as: :admin

  validates :name, presence: true, uniqueness: true

  has_many :groups
  has_many :memberships, through: :groups
  has_many :users, through: :memberships

  before_destroy :protect_if_has_group

  private

  def protect_if_has_group
    groups.count == 0
  end

  public

  def self.for_select
    all.map { |pg| [pg.name, pg.id] }
  end

  def to_s
    name
  end
end
