class ApplicationJob < ActiveJob::Base
    Telegram::Bot::Client.default_async_job.rescue_from(Telegram::Bot::Error) do |error|
        Rails.logger.info error.inspect
    end
end
