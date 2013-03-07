puts "Create default users"
AdminUser.find_or_create_by_email(:email => 'admin@happycompany.com', :password => 'secret', :password_confirmation => 'secret')
User.find_or_create_by_email(:email => 'user@happycompany.com', :password => 'secret', :password_confirmation => 'secret')