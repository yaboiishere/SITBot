class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception
private
  
  # Runs a rake task asyncronously in a child process
  #
  # for example, in any controller:
  #   async_rake("async:import_fixtures")
  #   async_rake("db:maintenance:cleanup", table: "things", ids: [12, 114, 539])
  #
  # Options will be converted to strings and passed as unix env variables.
  # The rake tasks will then be responsible of retrieving and parsing them
  # (e.g. if they are supposed to be collections).
  #
  def async_rake(task, options = {})
    options[:rails_env] ||= Rails.env

    # format the options as unix environmental variables
    env_vars = options.map { |key, value| "#{key.to_s.upcase}='#{value.to_s}'" }
    env_vars_string = env_vars.join(' ')

    log_file = File.join(Rails.root, "log/async_rake.#{Rails.env}.log")

    # fire and forget
    Process.fork {
      exec("#{env_vars_string} bin/rake #{task} --trace 2>&1 >> #{log_file}")
    }
    # or:
    # system("#{env_vars_string} bin/rake #{task} --trace 2>&1 >> #{log_file} &")
  end
end
