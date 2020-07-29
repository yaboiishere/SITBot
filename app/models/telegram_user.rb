class TelegramUser < ApplicationRecord
	has_many :reviews
	has_many :toilets, :through => :reviews
end
