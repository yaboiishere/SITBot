namespace :discord do
	require 'discordrb'
	bot = Discordrb::Bot.new token: 'NTQzODM5NDgzNTg2Njc0NzA4.XYtwBQ.w9zShHXN6Nj26u0FThfSDG4n3B0'
	botc = Discordrb::Commands::CommandBot.new token: 'NTQzODM5NDgzNTg2Njc0NzA4.XTuRgA.o4nl2J9tRacu77c8J5590MPoC1g', prefix: '!'

	require 'rufus-scheduler'

	scheduler = Rufus::Scheduler.new



	bot.ready do |event|
			randold=1
			scheduler.every '20s' do
				gameOrWatch = rand(2)
				if gameOrWatch==0
					games = ["with your mom", "with fire", "with myself", "with knifes", "with my pickle", "a tune on the world's smallest violin", "with the dark arts", "with death", "dead"]
					num1 = rand(games.count)
					if randold == num1
						num1 = rand(games.count)
					end
					bot.game=games[num1]
					randold=num1
				else
					watchings = ["adult content","you","paint dry", "you suck at whatever you're doing"]
					num1 = rand(watchings.count)
					if randold == num1
						num1 = rand(watchings.count)
					end
					bot.watching=watchings[num1]
					randold=num1
				end
				scheduler.join
			end
		end


	bot.message(start_with: '@someone') do |event|
		if event.message.content.include? "hide"
			event.message.delete
			event.content.slice!("hide") 
		end
		event.message.delete
		users = Array.new
		puts event.server
		event.server.users.each do |u|
			puts u.name
			puts u.tag
			users.push(u)
		end
		num = rand(event.server.users.count)
		puts num
		chosen = users[num]
		if event.content == "@someone" || event.content == "@someone "
			jokes = [
				"Your family tree must be a cactus because everybody on it is a prick.",
				"If laughter is the best medicine, your face must be curing the world.",
				"You're so ugly, you scared the crap out of the toilet.",
				"No I'm not insulting you, I'm describing you.",
				"It's better to let someone think you are an Idiot than to open your mouth and prove it.",
				"If I had a face like yours, I'd sue my parents.",
				"Your birth certificate is an apology letter from the condom factory.",
				"I guess you prove that even god makes mistakes sometimes.",
				"The only way you'll ever get laid is if you crawl up a chicken's ass and wait.",
				"You're so fake, Barbie is jealous.",
				"I’m jealous of people that don’t know you!",
				"My psychiatrist told me I was crazy and I said I want a second opinion. He said okay, you're ugly too.",
				"You're so ugly, when your mom dropped you off at school she got a fine for littering.",
				"If I wanted to kill myself I'd climb your ego and jump to your IQ.",
				"You must have been born on a highway because that's where most accidents happen.",
				"Brains aren't everything. In your case they're nothing.",
				"I don't know what makes you so stupid, but it really works.",
				"I can explain it to you, but I can’t understand it for you.",
				"Roses are red violets are blue, God made me pretty, what happened to you?",
				"Behind every fat woman there is a beautiful woman. No seriously, your in the way.",
				"Calling you an idiot would be an insult to all the stupid people.",
				"You, sir, are an oxygen thief!",
				"Some babies were dropped on their heads but you were clearly thrown at a wall.",
				"Don't like my sarcasm, well I don't like your stupid.",
				"Why don't you go play in traffic.",
				"Please shut your mouth when you’re talking to me.",
				"I'd slap you, but that would be animal abuse.",
				"They say opposites attract. I hope you meet someone who is good-looking, intelligent, and cultured.",
				"Stop trying to be a smart ass, you're just an ass.",
				"The last time I saw something like you, I flushed it.",
				"I'm busy now. Can I ignore you some other time?",
				"You have Diarrhea of the mouth; constipation of the ideas.",
				"If ugly were a crime, you'd get a life sentence.",
				"Your mind is on vacation but your mouth is working overtime.",
				"I can lose weight, but you’ll always be ugly.",
				"Why don't you slip into something more comfortable... like a coma.",
				"Shock me, say something intelligent.",
				"If your gonna be two faced, honey at least make one of them pretty.",
				"Keep rolling your eyes, perhaps you'll find a brain back there.",
				"You are not as bad as people say, you are much, much worse.",
				"I don't know what your problem is, but I'll bet it's hard to pronounce.",
				"You get ten times more girls than me? ten times zero is zero...",
				"There is no vaccine against stupidity.",
				"You're the reason the gene pool needs a lifeguard.",
				"Sure, I've seen people like you before - but I had to pay an admission.",
				"How old are you? - Wait I shouldn't ask, you can't count that high.",
				"Have you been shopping lately? They're selling lives, you should go get one.",
				"You're like Monday mornings, nobody likes you.",
				"Of course I talk like an idiot, how else would you understand me?",
				"All day I thought of you... I was at the zoo.",
				"To make you laugh on Saturday, I need to you joke on Wednesday.",
				"You're so fat, you could sell shade.",
				"I'd like to see things from your point of view but I can't seem to get my head that far up my ass.",
				"Don't you need a license to be that ugly?",
				"My friend thinks he is smart. He told me an onion is the only food that makes you cry, so I threw a coconut at his face.",
				"Your house is so dirty you have to wipe your feet before you go outside.",
				"If you really spoke your mind, you'd be speechless.",
				"Stupidity is not a crime so you are free to go.",
				"You are so old, when you were a kid rainbows were black and white.",
				"If I told you that I have a piece of dirt in my eye, would you move?",
				"You so dumb, you think Cheerios are doughnut seeds.",
				"So, a thought crossed your mind? Must have been a long and lonely journey.",
				"You are so old, your birth-certificate expired.",
				"Every time I'm next to you, I get a fierce desire to be alone.",
				"You're so dumb that you got hit by a parked car.",
				"Keep talking, someday you'll say something intelligent!",
				"You're so fat, you leave footprints in concrete.",
				"How did you get here? Did someone leave your cage open?",
				"Pardon me, but you've obviously mistaken me for someone who gives a damn.",
				"Wipe your mouth, there's still a tiny bit of bullshit around your lips.",
				"Don't you have a terribly empty feeling - in your skull?",
				"As an outsider, what do you think of the human race?",
				"Just because you have one doesn't mean you have to act like one.",
				"We can always tell when you are lying. Your lips move.",
				"Are you always this stupid or is today a special occasion?"]
			num = rand(0..74)
			joke = jokes[num]
		else
			joke = event.content.to_s.delete_prefix("@someone ")
		end
		event.respond "#{chosen.mention} #{joke} "
	end
	bot.message(start_with: '/giv') do |event|
		args = event.content.to_s.delete_prefix("/giv ")
		if event.content.to_s == "s"
			event.respond "You mean /allgivs"
			return
		end
		gif = " "
        Gif.all.each do |g|
          if g.gif_name == args
            gif = g.gif_name
          end
        end
          if gif != " "
            # url = "https://storage.googleapis.com/pgebot_storage/#{gif}.gif"
            # f = open(url)
            event.respond "https://storage.googleapis.com/pgebot_storage/#{gif}.gif"
          else
            event.respond "There is no Gif like this. Type /allgivs help to see all available Gifs"
          end
	end
	bot.message(start_with: "/allgivs") do |event|
		str = "Available Gifs(if you have ideas talk to amenoto) \n"
	    Gif.all.each do |g|
	        str =str +"#{g.gif_name} - #{g.description}\n"
	    end
	    event.respond str
	end
	bot.message(start_with: "/annoy") do |event|
		args = event.content.to_s.delete_prefix("/annoy ")
		event.message.delete
		puts event.server.id
		puts event.channel.id
		random_shit_id= "420882514492522496"
		pgefags_id= "403554080951238677"
		event.respond args
	end
	bot.message(start_with: "/help") do |event|
		response ="/help - well you know\n/allgivs - Shows you all GIFs available from this bot\n/giv *gif name* - Gives you the GIF!\n@someone - @s a random person with a random burn i found online\n@someone *text* - @s and burns a random person with your *text"
		event.respond response
	end
	bot.message(content: '/doc') do |event|
	event.message.delete
    ids = Quote.all.pluck(:id)
    q = rand(ids.count)
    chosen = Quote.find_by(id: ids[q])
    event.respond "Random quote:\n#{chosen.quote} - #{chosen.said_by} - added by: #{chosen.added_by}"
	end
	desc "start bot"
	task :run => :environment do
		if !bot.connected?
			bot.run
		end
	end	
	desc "stop bot"
	task :stop => :environment do
		bot.stop
	end
end