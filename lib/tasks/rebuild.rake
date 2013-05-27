namespace :db do
  desc "Drops, creates, migrates and seeds db"

  task(:rebuild => :environment) do
    puts Rails.env
    puts "Dropping db"
    Rake::Task['db:drop'].invoke
    puts "Creating db"
    Rake::Task['db:create'].invoke
    puts "Migrating db"
    Rake::Task['db:migrate'].invoke
    puts "Loading seeds"
    Rake::Task['db:seed'].invoke
  end
end