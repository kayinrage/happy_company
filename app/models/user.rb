class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  attr_accessor :skip_email_confirmation
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name, as: :user
  attr_accessible :email, :first_name, :last_name, :group_ids, :password, :password_confirmation, :skip_email_confirmation, as: :admin

  has_many :answers
  has_many :memberships
  has_many :groups, through: :memberships

  before_create :skip_confirmation_if_enabled

  private

  def skip_confirmation_if_enabled
    skip_confirmation! if self.skip_email_confirmation
  end

  public

  def to_s
    email
  end

  def display_name
    [first_name, last_name].compact.size < 2 ? email : "#{first_name} #{last_name}"
  end

  def name
    display_name
  end
end
