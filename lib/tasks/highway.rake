namespace :highway do
  desc 'Exporter edit first'
  task :export => :environment do
    puts "Export users who have logged in since 2017-06-30"

    # get a file ready, the 'data' directory has already been added in Rails.root
    filepath = File.join(Rails.root, 'data', 'recent_users.json')
    puts "- exporting users into #{filepath}"

    # the key here is to use 'as_json', otherwise you get an ActiveRecord_Relation object, which extends
    # array, and works like in an array, but not for exporting
    users = TelegramUser.all.as_json

    # The pretty is nice so I can diff exports easily, if that's not important, JSON(users) will do
    File.open(filepath, 'w') do |f|
      f.write(JSON.pretty_generate(users))
    end

    puts "- dumped #{users.size} users"
  end
  desc 'import users from recent users dump'
  task :import => :environment do
    puts "Importing current users"

    filepath = File.join(Rails.root, 'data', 'recent_users.json')
    abort "Input file not found: #{filepath}" unless File.exist?(filepath)

    current_users = JSON.parse(File.read(filepath))

    current_users.each do |cu|
      TelegramUser.create(cu)
    end

    puts "- imported #{current_users.size} users"
  end
end