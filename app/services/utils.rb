class Utils
  CHAR_SET_FOR_SECRET = [('a'..'z'), ('A'..'Z'), (0..9)].map { |i| i.to_a }.flatten.freeze
  CHAR_SET_FOR_SECRET_SIZE = CHAR_SET_FOR_SECRET.size.freeze

  def self.generate_secret(size = 16)
    (0...size).map { CHAR_SET_FOR_SECRET[rand(CHAR_SET_FOR_SECRET_SIZE)] }.join
  end

  def self.mailer_host
    HappyCompany::Application.config.action_mailer.default_url_options[:host]
  end

  def self.api_response(status, message)
    {status: status, message: message}
  end

  # for development / testing

  def self.add_membership_for_seed(user_name, group_names)
    user_id = User.find_by_first_name(user_name).id
    group_names.each { |group_name| Membership.create({user_id: user_id, group_id: Group.find_by_name(group_name).id}, as: :admin) }
  end
end
