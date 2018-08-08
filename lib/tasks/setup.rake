# frozen_string_literal: true

desc "Ensure that code is not running in production environment"
task :not_production do
  if Rails.env.production?
    puts ""
    puts "*" * 50
    puts "DO NOT RUN THIS IN PRODUCTION ENVIRONMENT"
    puts "*" * 50
    puts ""
    throw :error
  end
end

desc "Sets up the project by running migration and populating sample data"
task setup: [:environment, :not_production, "db:drop", "db:create", "db:migrate", "db:seed"]
