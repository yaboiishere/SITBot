class Review < ApplicationRecord
	belongs_to :telegram_user
	belongs_to :toilet
end
