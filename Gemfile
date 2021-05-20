source 'https://rubygems.org'
ruby "2.7.0"
git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '6.0.3.2'
gem 'rails_12factor', group: :production
gem "railties"
gem 'rufus-scheduler'
gem 'rbnacl'
gem 'google-cloud'
gem 'heroku_secrets', github: 'alexpeattie/heroku_secrets'
gem 'devise'
gem 'mysql2'
gem 'puma', '~> 5.3'
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'telegram-bot', '>=0.14.0'
gem 'jbuilder', '~> 2.5'
gem "google-api-client"
gem "googleauth"
gem "down"
gem 'phonegap-rails'
gem 'grpc'
gem "figaro"
gem "discordrb"
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'rspec-rails'
  gem 'rspec-its'
  gem 'spring-commands-rspec'
  gem 'whenever', require: false

end

group :development do
    gem 'capistrano',         require: false
    gem 'capistrano-rbenv',     require: false
    gem 'capistrano-rails',   require: false
    gem 'capistrano-bundler', require: false
    gem 'capistrano3-puma',   require: false
    gem 'capistrano-rails-console', require: false
    gem 'solargraph', group: :development
end
# group :development, :production do
#   gem 'capistrano', '~> 3.0', require: false
#   gem 'capistrano-unicorn-nginx', '~> 4.1.0'
#   gem 'capistrano-bundler', require: false
#   gem 'capistrano-rails', require: false
#   gem 'capistrano-rbenv', github: 'capistrano/rbenv', require: false
# end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
