class ParentGroup < ActiveRecord::Base

  attr_accessible :name, as: :admin

  validates :name, presence: true, uniqueness: true

  has_many :groups
  has_many :memberships, through: :groups
  has_many :users, through: :memberships

  def self.for_select
    all.map{|pg| [pg.name, pg.id]}
  end

  def to_s
    name
  end

end