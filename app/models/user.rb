class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable

  has_many :answers
  has_many :memberships
  has_many :groups, through: :memberships

  attr_accessor :skip_email_confirmation

  before_create :skip_confirmation_if_enabled

  public

  def to_s
    email
  end

  def display_name
    [first_name, last_name].compact.size < 2 ? email : "#{first_name} #{last_name}"
  end

  alias_method :name, :display_name

  private

  def skip_confirmation_if_enabled
    skip_confirmation! if self.skip_email_confirmation
  end
end
