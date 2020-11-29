class ApplicationJob < ActiveJob::Base
    Telegram::Bot::Client::AsyncJob.rescue_from(Telegram::Bot::Error) do |error|
        Rails.logger.info error.inspect
    end
end
