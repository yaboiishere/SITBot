namespace :timetable do
	bot = Telegram.bot
	pluralgeek_id = "-1001473157732"
	forwared_id = "-329128491"
	forwared_id_new = "-1001270079964"
	desc "pins days timetable to chat at 6:30"
	require 'telegram/bot'
	to_chat = pluralgeek_id
	task :start_of_day => :environment do
		h = Holiday.all.select("day", "month")
		puts Time.now.day
		puts Time.now.month
		h= h.to_a
		puts h[0].day
		h.each do |c|
			puts "day #{c.day}"
			puts "month #{c.month}"
			if (c.day.to_i==Time.now.day && c.month.to_i == Time.now.month)
				abort("Holiday: #{Holiday.find_by(day: Time.now.day, month: Time.now.month).name} ")				
			end
		end 
		weekday = Time.now.to_date
	    weekday.strftime("%A")
	    a = weekday.wday.to_i
	    if Time.now.hour > 13
	      a+=1
	    end
	    case a
	      when 1
	        puts "mon"
	        f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable1.png")
        	bot.send_sticker chat_id:to_chat, sticker:f
	      when 2
	       abort
	      when 3
	        puts "wed"
	        f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable3.png")
        	bot.send_sticker chat_id:to_chat, sticker:f
	      when 4
	        puts "thu"
	        f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable4.png")
        	bot.send_sticker chat_id:to_chat, sticker:f
	      when 5
	        puts "fri"
	        f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable5.png")
        	bot.send_sticker chat_id:to_chat, sticker:f
	    end
		
	end
	task :tester=> :environment do 
		f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable1.png")
        bot.send_sticker chat_id:forwared_id_new, sticker:f
	end
	desc "Tuesdays are later"
	task :tue => :environment do
		weekday = Time.now.to_date
	    weekday.strftime("%A")
	    a = weekday.wday.to_i
	    if a == 2
	    	f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable2.png")
	    	bot.send_sticker chat_id:to_chat, sticker:f
	    end
	end


end