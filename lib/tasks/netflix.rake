namespace :bot do
	pluralgeek_id = "-1001473157732"
	forwared_id = "-329128491"
	forwared_id_new = "-1001270079964"
	desc "Amenoto netflix notification"

	task :netflix => :environment do 
		if Time.now.day == 29
			Telegram.bot.send_message chat_id: forwared_id_new, text: "Pay cash to amenoto now"
		end
	end
	desc "just a test"
	task :test => :environment do
		Telegram.bot.send_message chat_id: forwared_id_new, text: "if you see this 6:30 should probably work"
	end
end