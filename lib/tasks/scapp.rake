# Inspired by: https://gist.github.com/ChuckJHardy/997746
require 'active_record'
require 'yaml'

namespace :scapp do

  # Checks and ensures task is not run in production.
  task :ensure_development_environment => :environment do
    if Rails.env.production?
      puts "Are you sure, you want to clean existing database and recreate it from migrations? Confirm by typing YES."
      r = STDIN.readline.strip
      unless r  == 'YES'
        raise "\nI'm sorry, I can't do that.\n(You're asking me to drop your production database.)"
      end
    end
  end

  # Custom install for developement environment
  desc "Install"
  task :install, [:locale] => [:ensure_development_environment, "db:migrate"] do |t, args|
    puts "\n===== MIGRATIONS SUCCESSFULLY LOADED ====\n"
    Rake::Task["scapp:populate"].invoke(args[:locale])
    Rake::Task["scapp:create_admin_account"].invoke
  end

  # Custom reset for developement environment
  desc "Reset"
  task :reset => [:ensure_development_environment, "db:drop", "db:create", "db:migrate", "db:test:prepare", "db:seed", "scapp:populate"]

  # Populates development data
  desc "Populate the database with development data using ActiveRecord Migrations.\n(Target specific version with VERSION=x)"
  task :populate, [:locale] => :environment do |t, args|
    puts "#{'*'*(`tput cols`.to_i)}\nChecking Environment... The database will be cleared of all content before populating.\n#{'*'*(`tput cols`.to_i)}"
    # Removes content before populating with data to avoid duplication
=begin
    Rake::Task['db:reset'].invoke

    # Rake using Rails Migrations
    dbconf = YAML::load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(dbconf[::Rails.env])
    ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'a'))
    ActiveRecord::Migrator.migrate([Rails.root, 'db', 'migrate'].join('/'), ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
=end

    puts "\n========= START LOADING SEEDS =========== \n"
    load("#{Rails.root}/db/install_#{args[:locale]}_seed.rb")

    puts "\n========== POPULATE TASK END ============ \n"
  end

  # Create administrator account
  desc "Create admin user with default password"
  task :create_admin_account => :environment do
    puts "\n========= CREATING ADMIN ACCOUNT ========\n"
    czech_locale = Locale.where(code: 'cs').first
    begin
      u = User.new(name: 'admin', email: 'admin@local.host', password: 'scapp123456789',
                   password_confirmation: 'scapp123456789', locale: czech_locale, slug: 'admin')
      u.save!(validate: false) # because of some problems with FriendlyId :/
      u.add_role :admin
      u.add_role :coach
      puts "+------------------- Administrátorský přístup ------------------+\n" +
           "| Email: admin@local.host                                       |\n" +
           "| Heslo: scapp123456789                                         |\n" +
           "|                                                               |\n" +
           "| !! Heslo z bezpečnostní důvodů změňte ihned po přihlášení !!  |\n"+
           "+---------------------------------------------------------------+"
    rescue Exception => e
      puts "ERROR: Vytváření administrátorského účtu selhalo z důvodu: #{e.message}"
    end
  end

end