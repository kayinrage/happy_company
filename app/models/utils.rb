class Utils

  def self.add_membership_for_seed(user_name, group_names)
    user_id = User.find_by_first_name(user_name).id
    group_names.each { |group_name| Membership.create({user_id: user_id, group_id: Group.find_by_name(group_name).id}, as: :admin) }
  end

end