require "factory_girl_rails"
include FactoryGirl::Syntax::Methods

# ================ helper methods ================ #

def header(name)
  puts "\n\r#{name.center(80, "-")}"
end

def create_groups_and_attach_them_to_parent(groups, parent)
  groups.each do |name|
    group = Group.where(name: name).first
    unless group
      group = create(:group, name: name, parent_group_id: parent.id)
      puts "- #{group.name} (id: #{group.id})"
    end
  end
end

# ================ seed's execution code ================ #

unless %w{test}.include?(Rails.env)

  header("ADMIN")
  ["admin@happycompany.com"].each do |email|
    admin = AdminUser.where(email: email).first
    unless admin
      admin = create(:admin_user, email: email)
      puts "- #{admin.email} (id: #{admin.id})"
    end
  end

end

if %w{development}.include?(Rails.env)

  header("USERS")
  %w{Irek Tomek Arek Rafal Bartek Blazej Szymon Darek Grzegorz}.each do |name|
    email = "#{name.downcase}@happycompany.com"
    user = User.where(email: email).first
    unless user
      user = create(:user, email: email, first_name: name, last_name: 'Happy', skip_email_confirmation: true)
      puts "- #{user.email} (id: #{user.id})"
    end
  end

  header("PARENT GROUPS")
  %w{Rooms Positions Teams}.each do |name|
    pg = ParentGroup.where(name: name).first
    unless pg
      pg = create(:parent_group, name: name)
      puts "- #{pg.name} (id: #{pg.id})"
    end
  end

  header("GROUPS")
  create_groups_and_attach_them_to_parent(%w{200 201 202 203}, ParentGroup.where(name: 'Rooms').first)
  create_groups_and_attach_them_to_parent(%w{Developers Designers Marketing}, ParentGroup.where(name: 'Positions').first)
  create_groups_and_attach_them_to_parent(%w{Mariachi Lumberjacks}, ParentGroup.where(name: 'Teams').first)

  header("MEMBERSHIPS")

  [{user_name: 'Irek', group_names: %w{200 Developers Mariachi}},
   {user_name: 'Tomek', group_names: %w{200 Developers Mariachi}},
   {user_name: 'Arek', group_names: %w{200 Designers Mariachi}},
   {user_name: 'Rafal', group_names: %w{201 Designers Lumberjacks}},
   {user_name: 'Bartek', group_names: %w{201 Developers Lumberjacks}},
   {user_name: 'Blazej', group_names: %w{202 Developers Lumberjacks}},
   {user_name: 'Szymon', group_names: %w{202 Developers Lumberjacks}},
   {user_name: 'Darek', group_names: %w{203 Marketing}},
   {user_name: 'Grzegorz', group_names: %w{203 Marketing}}].each do |params|
    Utils.add_membership_for_seed(params[:user_name], params[:group_names])
  end
  puts "- #{Membership.count} memberships have been created."

  header("RANDOM ANSWERS")

  User.all.each do |user|
    (Date.today-31.days..Date.today-1).to_a.each { |d| create(:answer, user_id: user.id, date: d) }
  end
  puts "- #{Answer.count} answers have been created."

end