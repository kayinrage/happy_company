puts "create default admin"
AdminUser.find_or_create_by_email(email: 'admin@happycompany.com', password: 'secret', password_confirmation: 'secret')

if %w{test development}.include?(Rails.env)

  puts "create default users"
  [{email: 'irek@happycompany.com', first_name: 'Irek'},
   {email: 'tomek@happycompany.com', first_name: 'Tomek'},
   {email: 'arek@happycompany.com', first_name: 'Arek'},
   {email: 'rafal@happycompany.com', first_name: 'Rafal'},
   {email: 'bartek@happycompany.com', first_name: 'Bartek'},
   {email: 'blazej@happycompany.com', first_name: 'Blazej'},
   {email: 'szymon@happycompany.com', first_name: 'Szymon'},
   {email: 'darek@happycompany.com', first_name: 'Darek'},
   {email: 'grzegorz@happycompany.com', first_name: 'Grzegorz'},
  ].each do |params|
    user = User.find_or_create_by_email(params.merge({password: 'secret', password_confirmation: 'secret', last_name: 'Happy'}), as: :user)
    user.confirm! unless user.confirmed?
  end

  puts "create default parent groups"
  %w{Rooms Positions Teams}.each do |name|
    ParentGroup.find_or_create_by_name({name: name}, as: :admin)
  end

  rooms_id = ParentGroup.find_by_name('Rooms').id
  positions_id = ParentGroup.find_by_name('Positions').id
  teams_id = ParentGroup.find_by_name('Teams').id

  puts "create default groups"
  %w{200 201 202 203}.each do |name|
    Group.find_or_create_by_name({name: name, parent_group_id: rooms_id}, as: :admin)
  end

  %w{Developers Designers Marketing}.each do |name|
    Group.find_or_create_by_name({name: name, parent_group_id: positions_id}, as: :admin)
  end

  %w{Mariachi Lumberjacks}.each do |name|
    Group.find_or_create_by_name({name: name, parent_group_id: teams_id}, as: :admin)
  end

  puts "create default memberships"

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

  puts "create random answers for past month"

  User.all.each do |user|
    (Date.today-30.days..Date.today).to_a.each { |d| user.answers.create({date: d, result: rand(10) == 0 ? rand(4) : 1}) }
  end

end