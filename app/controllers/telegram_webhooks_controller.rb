class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::MessageContext

  require "application_controller"
  require "google/apis/docs_v1"
  require "googleauth"
  require "googleauth/stores/file_token_store"
  require "fileutils"

  def givs!(*)
    str = "Available Gifs(if you have ideas talk to amenoto) \n"
    Gif.all.each do |g|
        str = str + "#{g.gif_name} - #{g.description}\n"
    end
    reply_with :message, text: str, message_id: chat["id"]
  end

  def giv!(*args)
    @tusers = TelegramUser.all
    if !@tusers.include?(from["username"])
      TelegramUser.new(name: from["username"])
    end
    if args.any?
        gif = " "
        Gif.all.each do |g|
          if g.gif_name ==args[0]
            gif = g.gif_name
          end
        end
          if gif != " "
            url = "https://storage.googleapis.com/pgebot_storage/#{gif}.gif"
            f = open(url)
            if update["message"]["reply_to_message"]
              bot.send_video chat_id: chat["id"], reply_to_message_id:update["message"]["reply_to_message"]["message_id"].to_i, video:f, text: gif
            else  
              reply_with :video, text: gif, video:f
            end
          else
            reply_with :message, text: "There is no Gif like this. Type /giv help to see all available Gifs"
          end
    else
      reply_with :message, text: "Type /givs to see all available Gifs"
    end
  end

  def newgivsss!(name, url, *args)
    require "down"
    require "fileutils"
    require "google/cloud/storage"
    storage = Google::Cloud::Storage.new project_id: Figaro.env.google_project_id, credentials: JSON.parse(Figaro.env.GOOGLE_APPLICATION_CREDENTIALS)
    bucket  = storage.bucket "pgebot_storage"
    tempfile = Down.download(url)
    if tempfile.size > 5*1024*1024
      bot.send_message chat_id:chat["id"], text: "File is too big"
      return
    end
    file = bucket.create_file tempfile.path, "#{name}.gif"
    bot.send_message chat_id:chat["id"], text: "Uploaded #{file.name}"
    names = Array.new
    Gif.all.each do |g|
      names.push(g.gif_name)
    end
    allfiles = Array.new
    bucket.files.each do |f|
      allfiles.push(f.name.delete_suffix(".gif"))
    end
    newfiles = allfiles - names
    if newfiles.any?
      newfiles.each do |f|
        params = [:gif_name => f.to_s.delete_suffix(".gif")]
        Gif.create(params)
      end
    end  
  end

  def timer!(min=0,sec=0, *reminderarr)
    if (min== 0 and sec == 0) or (min == "0" and sec == "0")
      reply_with :message, text: "Fuck off"
    else
      reply_with :message, text: "reminder set for #{min} mins and #{sec} seconds"

      require 'rufus-scheduler'
      scheduler = Rufus::Scheduler.new
      time = min*60 + sec
      time = time.to_s + "s"
      scheduler.in time do
        if reminderarr[0] != nil
          reminder = ""
          reminderarr.each do |r|
            reminder += r
            reminder += " "
          end
          str = "@#{from["username"]} #{reminder}"
          reply_with :message, text: str
        else
          str = "@#{from["username"]} your timer is up"
          reply_with :message, text: str
        end
      end
    end
  end

  def teachers!(*args)
    teacherslist = " [DEPRECATED BTW Y YOU DUMB]\nI срок:\n----------------------------------------------\nЕвгени Илиев - БЕЛ\nЕлка Николова - ЗИП / Математика\nАнтоанета Атанасова - Свят и личност\nЦветан Недялков\n-----\n  ФВС\n  ФВС Модул\n  Час на класа \n-----\nМарияна Костадинова - Английски език\nПламена Станчева\n-----\n  Интернет Програмиране\n  ООП\n  Производствена практика\n-----\nДимитър Аврамов\n-----\n  Компютърна графика и дизайн\n  Вградени управляващи системи\n  Практика по вградени управляващи системи\n-----\nАндрей Тодоров - Програмиране на асемблерни езици\nинж. Ради Добрев / Г. Гочев - Практика по Периферни устройства \nАсиер Бейжет - Производствена практика\nСилва Славчева - ЗИП-Английски\n----------------------------------------------\nII срок:\nДаниела Николова - Микропроцесорни системи\nинж. Ради Добрев - Компютърни мрежи\nПламена Станчева - Практика по Интернет програмиране\nДимитър Аврамов\n-----\n  Практика по Компютърна графика и дизайн\n  Практика по Компютърни мрежи\n  Практика по Комплексна практика по специалността\n-----\nГ. Гочев\n-----\n  Компютърни мрежи\n  Комплексна практика по специалността\n-----\nД. Митева / Д. Николова - Практика по микропроцесорни системи"
    bot.send_message chat_id: chat["id"], text:teacherslist
  end

  def headmaster!(*args)
    bot.send_photo chat_id: chat["id"], photo: "https://storage.googleapis.com/pgemultibot_pics/asd.jpg"
  end

  def timetable!(*args)
    Opt.where(optiontype: "last_message_id").first_or_create.update(value: update["message"]["message_id"])
    if args.nil?
      weekday = DateTime.new
      weekday.strftime("%A")
    end
    f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable1.png")
    case args[0].to_s
      when "mon"
        bot.send_sticker chat_id:chat["id"], sticker:f
      when "tue"
        f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable2.png")
        bot.send_sticker chat_id:chat["id"], sticker:f
      when "wed"
        f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable3.png")
        bot.send_sticker chat_id:chat["id"], sticker:f
      when "thu"
        f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable4.png")
        bot.send_sticker chat_id:chat["id"], sticker:f
      when "fri"
        f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable5.png")  
        bot.send_sticker chat_id:chat["id"], sticker:f
      else
        weekday = Time.now.to_date
        weekday.strftime("%A")
        a = weekday.wday.to_i
        if Time.now.hour > 13
          a+=1
        end
        case a
          when 1
            bot.send_sticker chat_id:chat["id"], sticker:f
          when 2
            f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable2.png")
            bot.send_sticker chat_id:chat["id"], sticker:f
          when 3
            f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable3.png")
            bot.send_sticker chat_id:chat["id"], sticker:f
          when 4
            f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable4.png")
            bot.send_sticker chat_id:chat["id"], sticker:f
          when 5
            f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable5.png")
            bot.send_sticker chat_id:chat["id"], sticker:f
          else
            bot.send_sticker chat_id:chat["id"], sticker:f
         end
    end

  end

  def ideas!(*)
    bot.send_message chat_id:chat["id"], text: "Here: https://trello.com/b/AmiWwHbR"
  end

  def vakancii!(*)
    bot.send_message chat_id:chat["id"], text: "23.09.2019 - Независимост 22ри\n01.11.2019 - 03.11.2019 вкл. - Есенна\n21.12.2019 - 05.01.2020 вкл. - Коледна\n05.02.2020 - Междусрочна\n03.03.2020 - Познай от 3 пъти\n16.04.2020 - 20.04.2020 вкл. - Пролетна\n01.05.2020 - Ден на труда\n06.05.2020 - Ден на храбростта и празник на българската армия"
  end

  def help!(*)
    respond_with :message, text: t('.content')
  end

  def tests!(*args)
    subjects = ["mat", "bel", "oop", "vus", "kgd", "chep", "svqt", "inet", "zipmat", "zipist", "zipae", "ass"]
    types = ["prak", "vh", "izh", "normal", "klasno"]
    if args.any?
      subject = false
      type = false
      q = String.new
      subjects.each do |s|
        if s == args[0]
          subject = true
          q = s
          break
        end
      end
      types.each do |t|
        if t == args[0]
          type == true
          q = t
          break
        end
      end
      if !subject and types
        str = ""
        Test.where(test_type: q).order(:date).each do |t|
          str+="Subject: #{t.subject} Type:#{t.test_type} Date:#{t.date}\n"
        end
        bot.send_message chat_id: chat["id"], text: str
      end
      if subject and !types
        str = ""
        Test.where(subject: q).order(:date).each do |t|
          str+="Subject: #{t.subject} Type:#{t.test_type} Date:#{t.date}\n"
        end
        bot.send_message chat_id: chat["id"], text: str
      end        
      if subject and type
        bot.send_message chat_id:chat["id"], text:"Invalid query: #{args[0]}"
      end
    else
      str = String.new
      Test.all.order(:date).each do |t|
          str+="Subject: #{t.subject} Type:#{t.test_type} Date:#{t.date}\n"
      end
      bot.send_message chat_id: chat["id"], text: str
    end
  end

  def addtest!(subject, date, type="normal")
    begin 
      if Date.parse(date)<Time.now 
        bot.send_message chat_id: chat["id"], text: "Invalid date: #{Date.parse(date)}"
        return
      end 
       rescue Exception => e
        bot.send_message chat_id: chat["id"], text: "Wrong format. Do addtest subject yy/mm/dd type(Optional. Normal if left empty)"
        return
    end
    sub  = false
    typ = false
    qs = ""
    qt = ""
    types = ["prak", "vh", "izh", "normal", "klasno"]
    subjects = ["mat", "bel", "oop", "vus", "kgd", "chep", "svqt", "inet", "zipmat", "zipist", "zipae", "ass"]
    subjects.each do |s|
      if subject == s
        sub = true
        qs = subject 
        break
      end
    end
    types.each do |t|
      if type == t
        typ = true
        qt = t
        break
      end
      if date == t
        bot.send_message chat_id: chat["id"], text: "Wrong format. Do addtest subject yy/mm/dd type(Optional. Normal if left empty)"
      end
    end
    if sub and typ 
      if Test.where(subject: subject, date: Date.parse(date), test_type: type).exists?
        bot.send_message chat_id: chat["id"], text: "Test already exists"
        return
      else
        Test.create(subject: subject, date: Date.parse(date), test_type: type)
        bot.send_message chat_id: chat["id"], text: "Added test successful"
        return
      end
    end
    if !sub 
      bot.send_message chat_id: chat["id"], text: "Unlnown subject #{subject}. /test_sub for all subjects"
    end
    if !typ
      bot.send_message chat_id: chat["id"], text: "Unlnown subject #{type}. /test_type for all types"
    end
  end

  def test_sub!(*args)
    str = ""
    subjects = ["mat", "bel", "oop", "vus", "kgd", "chep", "svqt", "inet", "zipmat", "zipist", "zipae", "ass"]
    subjects.each do |s|
      str+="#{s}, "
    end
    str = str.delete_suffix(", ")
    bot.send_message chat_id: chat["id"], text: str
  end

  def test_type!(*args)
    str = ""
    types = ["prak", "vh", "izh", "normal", "klasno"]
    types.each do |t|
      str+="#{t}, "
    end
    str = str.delete_suffix(", ")
    bot.send_message chat_id: chat["id"], text: str
  end

  def places!(*args)
    @telegramusers = TelegramUser.all
    @tusers = Array.new
    TelegramUser.all.each do |t|
      @tusers << t.name
    end
    if !(@tusers.include?(from["username"]))
       @telegramusers = TelegramUser.new(name:from["username"])
       @telegramusers.save
    end
    if args.any?
      @alltoilets = " "
      Toilet.all.each do |t|
        @alltoilets += t.name
      end
      if @alltoilets.include?(args[0])
        t=Toilet.find_by name: args[0]
        t.maps_link = "https://www.google.com/maps/?q=#{t.x},#{t.y}"
        str = "Name: #{t.name}, Location: #{t.location} \n"
        respond_with :message, text: str
        bot.send_location longitude: t.y, latitude: t.x, text:str, chat_id:chat["id"]
      else 
        respond_with :message, text: "No toilet with that name."
      end
    else
      str = "Known places: \n"
      Toilet.all.each do |t|
       str += t.name
       str += ", "
      end
      str = str.delete_suffix(", ")
      str +="\n"
      str += "To check reviews /review or to check by toilet /review *name of toilet*\nTo add a review /addreview for more info\nTo add more toilets https://pgegifbot.herokuapp.com/toilets"
      respond_with :message, text: str
    end
  end

  def addreview!(place=nil, rating=nil, *opinions)
    if place==nil && rating==nil
      respond_with :message, text: "Usage: /addreview place rating(out of 10) opinions  ex: /addreview Kaufland 5 meh"
      return
    end
    tid = Toilet.find_by(name: place).id
    if tid == nil
      err = "No place with that name in the DB"
    end
    uid = TelegramUser.find_by(name: from["username"]).id
    rev = Review.find_by(toilet_id: tid, telegram_user_id: uid)
    if err
      respond_with :message, text: err
      return
    end
    if rev == nil
      fromu = from["username"]
      tid = Toilet.find_by(name: place)
      tuid = TelegramUser.find_by(name: fromu)
      if !TelegramUser.exists?(name: fromu)
        @kek = TelegramUser.all
        @kek = TelegramUser.new(id: (TelegramUser.last.id)+1, name:from["username"])
        @kek.save
      end
      opinion = ""
      opinions.each do |o|
        opinion += "#{o} "
      end
      opinion.delete_suffix!(" ")
      params = {telegram_user_id:tuid.id ,toilet_id: tid.id, review: rating, opinion: opinion, created_at:Time.now, updated_at:Time.now}
      @kek = Review.all
      @kek = Review.new(params)
      if @kek.save
        respond_with :message, text: "#{place} is #{rating}/10 opinion: #{opinion}"
      end
    else
      respond_with :message, text: "You have already rated this toilet. /delreview *name of review you wish to delete* to delete your review."
    end
  end

  def delreview!(place=nil)
    if place == nil
      respond_with :message, text: "Usage: /delreview review  ex:/delreview Kaufland"
      return
    end
    tid = Toilet.find_by(name: place).id
    uid = TelegramUser.find_by(name: from["username"])
    rev = Review.find_by(toilet_id: tid, telegram_user_id: uid)
    respond_with :message, text: "Review deleted!"
    rev.delete
  end

  def review!(place=nil)
    if place == nil
      str = "All reviews: \n"
      Toilet.all.each do |t|
        allReviews = Array.new
        Review.all.each do |r|
          if r.toilet_id == t.id
            allReviews << r
          end
        end
        allReviews.each do |r|
          str += "By: #{r.telegram_user.name} | Rating: #{r.review}/10 \nPlace: #{t.name}\nOpinion: #{r.opinion}\n"
          respond_with :message, text: str
          str = ""
        end
        allReviews = Array.new
      end
      return
    end
    str = "Reviews for #{place}: \n"
    kek = Toilet.find_by(name: place)
    allReviews = Array.new
    Review.all.each do |r|
      if r.toilet_id == kek.id
        allReviews << r
      end
    end
    allReviews.each do |r|
      str += "By: #{r.telegram_user.name} | Rating: #{r.review}/10\n Place: #{place} \nOpinion: #{r.opinion}\n"
      respond_with :message, text: str
      str = ""
    end
    str += "\nTo check by place /review *name of toilet*\nTo add a review /addreview for more info\nTo add more toilets https://pgegifbot.herokuapp.com/toilets"
  end

  def q!(*args)
    Quote.all.delete_all
    service = Google::Apis::DocsV1::DocsService.new
    service.client_options.application_name = "My Project"
    service.authorization =  ApplicationHelper.authorize
    document_id = ENV["DOCS_DOC_ID"]
    document = service.get_document document_id
    itermm = 0
    str =String.new
    whole = ""
    wholearr = Array.new
    color = Array.new
    krefa = false
    participants = false
    document.body.content.each do |d|
      if d.paragraph != nil
        if d.paragraph.elements[0].text_run.content == "Distinguishing mark to separate names from doc change something and i’ll kill you\n" or d.paragraph.elements[0].text_run.content == "Distinguishing mark to separate names from doc change something and i’ll kill you"
          participants = true
          puts "\n\n\n\n\n\n\n\n\n"
          next
        end
        if participants
          if d.paragraph.elements[0].text_run.content != "\n" && d.paragraph.elements[0].text_run.content != "Крефа:\n"
            line = String.new
            line = d.paragraph.elements[0].text_run.content
            stripped = line.strip
            if stripped.start_with? "{"
              krefa = true
              next
            end
            if stripped.start_with? "}"
              krefa= false
              next
            end
            if !krefa
              line = line.split('-')
              line.each do |l|
                if l != line[-1]
                  str +=l
                else
                  if d.paragraph.elements[0].text_run.text_style.foreground_color.color.rgb_color != nil
                    col = String.new
                    col = d.paragraph.elements[0].text_run.text_style.foreground_color.color.rgb_color.to_h rescue ""
                    col = col.to_s
                    col = col.delete("{")
                    col = col.delete("}")
                    adder = String.new
                    if Color.find_by(rgb: "#{col}")!=nil
                      adder = Color.find_by(rgb: "#{col}").by
                    else
                      adder = "Unknown"
                    end
                      l = l.gsub("\n",'')
                      l = l.delete_prefix " "
                    Quote.where(quote: str, said_by: l, added_by: adder).first_or_create
                    str+="added by: #{adder} - #{l}"

                    whole+=str
                    wholearr << str
                    str = ""
                    color << d.paragraph.elements[0].text_run.text_style.foreground_color.color.rgb_color.to_h
                  end
                end
              end
            else
              col = String.new
              col = d.paragraph.elements[0].text_run.text_style.foreground_color.color.rgb_color.to_h rescue ""
              col = col.to_s
              col = col.delete("{")
              col = col.delete("}")
              adder = String.new
              if Color.find_by(rgb: "#{col}")!=nil
                adder = Color.find_by(rgb: "#{col}").by
              else
                adder = "Unknown"
              end
              cnt = d.paragraph.elements[0].text_run.content.delete_suffix("\n")
              str ="#{cnt} added by: #{adder} - Krefa\n"
              Quote.where(quote: cnt, said_by: "Krefa", added_by: adder).first_or_create
              whole+=str
              wholearr << str
              str = ""
            end
          end
        else
          if d.paragraph.elements[0].text_run.content != "Participants:" or d.paragraph.elements[0].text_run.content != "Participants:\n"
            col = String.new
            col = d.paragraph.elements[0].text_run.text_style.foreground_color.color.rgb_color.to_h rescue ""
            col = col.to_s
            col = col.delete("{")
            col = col.delete("}")
            name = d.paragraph.elements[0].text_run.content.delete_suffix("\n")
            puts col + name
            Color.where(by: name, rgb: col).first_or_create
          end
        end
      end
    itermm=itermm+1
    end
    puts color.uniq
    bot.send_message chat_id: chat["id"], text: "Done"
    file1 = File.open("token.yaml", "w")
    file1.write "placeholder text lol"
    file1.close
  end
  def menu!(*)
    bot.send_message chat_id:chat["id"], text: "PGEMultiBot Menu", reply_markup: {
      inline_keyboard: [
        [
          {text: "Teachers", callback_data: 'teachers'},
          {text: "Headmaster", callback_data: 'headmaster'},
        ],
        [
          {text: "Vakancii", callback_data: 'vakancii'},
          {text: "Timetable", callback_data: 'timetable'},
        ],
        [
          {text: "Exit", callback_data: 'return'},
        ],
      ],
    }
  end

  def callback_query(data)
    case data
      when "teachers"
        teachers!
      when "headmaster"
        headmaster!
      when "vakancii"
        vakancii!
      when "timetable"
        weekday = Time.now.to_date
        weekday.strftime("%A")
        a = weekday.wday.to_i
        if Time.now.hour > 13
          a+=1
        end
        case a
          when 1
            bot.send_sticker chat_id:chat["id"], sticker:f
          when 2
            f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable2.png")
            bot.send_sticker chat_id:chat["id"], sticker:f
          when 3
            f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable3.png")
            bot.send_sticker chat_id:chat["id"], sticker:f
          when 4
            f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable4.png")
            bot.send_sticker chat_id:chat["id"], sticker:f
          when 5
            f = open("https://storage.googleapis.com/pgemultibot_pics/PGETimetable5.png")
            bot.send_sticker chat_id:chat["id"], sticker:f
          else
            bot.send_sticker chat_id:chat["id"], sticker:f
        end
      when "return"
        bot.delete_message chat_id: update["callback_query"]["message"]["chat"]["id"], message_id: update["callback_query"]["message"]["message_id"]
      when "guessed"
        if TelegramUser.where(name: from["username"]).first.answered
          bot.send_message chat_id: chat["id"], text: "You've already answered @#{from["username"]}"
        else
          a = Docpoint.where(user: from["username"]).first_or_create
          if a.points.nil?
            a.points = 1
          else
            a.points = a.points+1
          end
          a.save
          oof = TelegramUser.where(name: from["username"]).first
          oof.answered = true
          oof.save
          bot.send_message chat_id: chat["id"], text: "#{from["username"]} guessed correctly"
        end
      when "notguessed"
        if TelegramUser.where(name: from["username"]).first.answered
          bot.send_message chat_id: chat["id"], text: "You've already answered @#{from["username"]}"
        else
          a = Docpoint.where(user: from["username"]).first_or_create
          if a.points.nil?
            a.points = -1
          else
            a.points = a.points-1
          end
          a.save
          oof = TelegramUser.where(name: from["username"]).first
          oof.answered = true
          oof.save
          bot.send_message chat_id: chat["id"], text: "#{from["username"]} guessed wrong. What a looser"
        end
    end
  end

  def inline_query(query, _offset)
    if query == "" or query == " "
      query = Gif.all
    else
      query = Gif.where("gif_name like '#{query}%'")
    end
    results = []
    query.each do |i|
      results <<{  
        caption: "#{i.gif_name}",
        title: "#{i.gif_name}",
        type: :gif,
        id: "#{i.id}",
        description: "#{i.description}",
        gif_url: "https://storage.googleapis.com/pgebot_storage/#{i.gif_name}.gif",
        thumb_url: "https://storage.googleapis.com/pgebot_storage/#{i.gif_name}.gif",
      }
    end
    answer_inline_query(results)
  end

  def chosen_inline_result(result_id, _query)
    session[:last_chosen_inline_result] = result_id
  end

  def last_chosen_inline_result!(*)
    result_id = session[:last_chosen_inline_result]
    if result_id
      respond_with :message, text: t('.selected', result_id: result_id)
    else
      respond_with :message, text: t('.prompt')
    end
  end

  def random!(*args)
    ids = Quote.all.pluck(:id)
    q = rand(ids.count)
    chosen = Quote.find_by(id: ids[q])
    bot.send_message chat_id: chat["id"], text: "Random quote:\n#{chosen.quote} - #{chosen.said_by} - added by: #{chosen.added_by}"
  end

  def game!(*args)
    if Opt.where(optiontype: "last_game_id").first.nil?
      Opt.where(optiontype: "last_game_id", value:  update["message"]["message_id"]+1).first_or_create
    end
    if Opt.where(optiontype: "last_game_id").first.value.nil?
      Opt.where(optiontype: "last_game_id", value:  update["message"]["message_id"]+1).first_or_create
    else
      kek = Opt.where(optiontype: "last_game_id").first.value
      bot.delete_message chat_id: chat["id"], message_id: kek rescue ""
    end
    Opt.where(optiontype: "last_game_id").first_or_create.update(value: update["message"]["message_id"]+1)
    TelegramUser.all.each do |t|
      t.answered = false
      t.save
    end   
    ids = Quote.all.pluck(:id)
    q = rand(ids.count)
    chosen = Quote.find_by(id: ids[q])
    sayers = Quote.all.pluck(:said_by)
    sayers = sayers.uniq
    answers = Array.new
    3.times do
      randomizer = rand(sayers.count) 
      answers<<sayers[randomizer]
      sayers.delete_at(randomizer)
    end
    answers<<chosen.said_by
    answers = answers.uniq
    if answers.count < 4
      randomizer = rand(sayers.count) 
      answers<<sayers[randomizer]
      sayers.delete_at(randomizer)
    end
    answers = answers.shuffle
      bot.send_message chat_id:chat["id"], text: "Random quote:\n#{chosen.quote} - added by: #{chosen.added_by}\nWho said it?\nAnswers:", reply_markup: {
      inline_keyboard: [
        [
          {text: "A: #{answers[0]}", callback_data: "#{check(answers[0],chosen.said_by, from["username"])}"},
          {text: "B: #{answers[1]}", callback_data: "#{check(answers[1],chosen.said_by, from["username"])}"},
        ],
        [
          {text: "C: #{answers[2]}", callback_data: "#{check(answers[2],chosen.said_by, from["username"])}"},
          {text: "D: #{answers[3]}", callback_data: "#{check(answers[3],chosen.said_by, from["username"])}"},
        ],
      ],
    }
  end
  def last!(*args)
    # if from["username"] == "ivo_tanev1"
    #   return
    # end
    if args.first
      saidby = args.first.capitalize() 
      if !(Integer(saidby) rescue false) and (Integer(args.second) rescue false)
        sayers = Quote.all.pluck(:said_by)
        if sayers.include? saidby
          sayer = Quote.where(said_by:saidby).reverse
          sayer = sayer[0...args.second.to_i]
          str = "Last #{args[1]} quotes from #{saidby}:\n"
          br = 1
          sayer.reverse.each do |c|
            if br%50 == 0
              bot.send_message chat_id: chat["id"], text: str
              str = ""
            end
            str += "#{c.quote} - added by: #{c.added_by}\n"
            br += 1
          end
          str.delete_suffix("\n")
          bot.send_message chat_id: chat["id"], text:str

        else
          bot.send_message chat_id: chat["id"], text:"Ave ei kaval @#{from["username"]}"
        end
        return
      end
      unless (Integer(saidby) rescue false)
        if args.second
          bot.send_message chat_id: chat["id"], text: "da ta eba i kavala veche i space li se nauchi da polzvash @#{from["username"]}"
          return
        end
        sayers = Quote.all.pluck(:said_by)
        if sayers.include? saidby
          sayer = Quote.where(said_by:saidby)
          str = "All quotes from #{saidby}:\n"
          sayer.each do |s|
            str+= "#{s.quote} - added by: #{s.added_by}\n"
          end
          bot.send_message chat_id: chat["id"], text:str
        else
          bot.send_message chat_id: chat["id"], text:"Ave ei kaval @#{from["username"]}"
        end
      else
        qs = Quote.all.reverse
        chosen = qs[0...args[0].to_i]
        str = "Last #{args[0]} quotes:\n"
        br = 1
        chosen.reverse.each do |c|
          if br%50 == 0
            bot.send_message chat_id: chat["id"], text: str
            str = ""
          end
          str += "#{c.quote} - #{c.said_by} - added by: #{c.added_by}\n"
          br += 1
        end
        str.delete_suffix("\n")
        bot.send_message chat_id: chat["id"], text: str
        puts "wasdasdadasda"
      end
    else
        qs = Quote.all.reverse.first
        bot.send_message chat_id: chat["id"], text: "Last quote:\n#{qs.quote} - #{qs.said_by} - added by: #{qs.added_by}"
    end

  end

  def check(str, right, user)
    if str == right
      "guessed"
    else
      "notguessed"
    end
  end

  def doc!
    bot.send_message chat_id:chat["id"], text: "Non suspicious link: shorturl.at/epxU9"
  end

  def scoreboard!(*args)
    i = 1
    str = String.new
    unless Docpoint.any?
      bot.send_message chat_id:chat["id"], text: "Scoreboard is empty"
    else
      strftime = "Rankings:\n"
      Docpoint.all.order(:points).reverse.each do |s|
        str += "#{i.ordinalize} place: #{s.user} with #{ActionController::Base.helpers.pluralize(s.points, "point")}\n"
        i+=1
      end
      bot.send_message chat_id: chat["id"], text: str
    end
  end

  def clearscoreboard!(*args)
    clearers = ["yaboiishere", "ivo_tanev1"]
    if clearers.include?(from["username"])
      winner = Docpoint.all.order(:points).reverse.first
      Alltime.where(name: winner.user, points: winner.points).first_or_create
      Docpoint.all.delete_all
      bot.send_message chat_id:chat["id"], text: "Done"
    else
      bot.send_message chat_id:chat["id"], text: "Insufficient privileges"
    end
  end
  def alltime!
    i = 1
    str = String.new
    unless Alltime.any?
      bot.send_message chat_id:chat["id"], text: "Scoreboard is empty"
    else
      strftime = "All time Rankings:\n"
      Alltime.order(:points).limit(10).reverse.each do |s|
        str += "#{i.ordinalize} place: #{s.name} with #{ActionController::Base.helpers.pluralize(s.points, "point")}\n"
        i+=1
      end
      bot.send_message chat_id: chat["id"], text: str
    end
  end
  def message(*args)
    if from["is_bot"]
      return
    end
    TelegramUser.where(name: from["username"], telegramid: from["id"]).first_or_create
    if update["message"]["new_chat_members"]  
      update["message"]["new_chat_members"].each do |n|
        handle = n["username"].nil? ? "#{n["first_name"]} #{n["last_name"]}" : "#{n["username"]}"
        insults = ["Who the fuck let @#{handle} in", "Who left the door open? Look what just came in @#{handle}", "Mahai sa ve @#{handle}"]
        insult = insults[rand(insults.count)]
        bot.send_message chat_id: chat["id"],  text: "#{insult}"
        return
      end
    end
    if update["message"]["left_chat_member"]  
      n = update["message"]["left_chat_member"]  
      handle = n["username"].nil? ? "#{n["first_name"]} #{n["last_name"]}" : "#{n["username"]}"
      insults = 
      [
        "@#{handle} finally fucking left",
        "@#{handle} left. Thank God",
        "@#{handle} what a lil bitch"
      ]
      insult = insults[rand(insults.count)]
      bot.send_message chat_id: chat["id"],  text: "#{insult}"
      return
    end
    unless update["message"]["text"].nil?
      if update["message"]["text"].include? "@everyone"
        users = String.new
        TelegramUser.all.each do |u|
          tuser = bot.get_chat_member user_id: u.telegramid.to_i, chat_id: chat["id"]
          status = tuser["result"]["status"]
          if status == "creator" || status == "member" || status == "administrator" || status == "restricted"
            users+="@#{u.name} "
          end
        end
        bot.send_message chat_id: chat["id"], text: users
      end
    end
  end

  def count!(*args)
    str = String.new
    str = Quote.pluck(:added_by).group_by(&:itself).map { |k,v| [k, v.count] }.to_s
    str = str.tr('"','')
    str = str.tr(']','')
    str = str.tr('[','')
    str = str.tr(' ','')
    kek = str.split ','
    str = ""
    kek = Hash[*kek.flatten(1)]
    kek = kek.sort_by {|k, v| [-v.to_i,k]}.to_h
    kek.each do |k,v|
      if v.to_i == 1
        str+= "1 quote was added by #{k}\n"
      else
        str+= "#{v} quotes were added by #{k}\n"
      end
    end
    str = str.delete_suffix "\n"
    bot.send_message chat_id: chat["id"], text: "There are #{Quote.count} quotes of which:\n#{str}"
  end
  def tapak!(*args)
    str = String.new
    str = Quote.pluck(:said_by).group_by(&:itself).map { |k,v| [k, v.count] }.to_s
    str = str.tr('"','')
    str = str.tr(']','')
    str = str.tr('[','')
    str = str.tr('\n','')
    str = str.tr("\\",'')
    kek = str.split ','
    str = ""
    kek = Hash[*kek.flatten(1)]
    kek = kek.sort_by {|k, v| [-v.to_i,k]}.to_h
    kek.each do |k,v|
      k=k.delete_prefix(" ")
      if v.to_i == 1
        next
      else
        str+= "#{k} has said#{v} recorded dumb things\n"
      end
    end
    str = str.delete_suffix "\n"
    bot.send_message chat_id: chat["id"], text: "There are #{Quote.count} quotes of which:\n#{str}"
  end
  def hatapak!(*args)
    str = String.new
    str = Quote.pluck(:said_by).group_by(&:itself).map { |k,v| [k, v.count] }.to_s
    str = str.tr('"','')
    str = str.tr(']','')
    str = str.tr('[','')
    str = str.tr('\n','')
    str = str.tr("\\",'')
    kek = str.split ','
    str = ""
    kek = Hash[*kek.flatten(1)]
    kek = kek.sort_by {|k, v| [-v.to_i,k]}.to_h
    kek.each do |k,v|
      k=k.delete_prefix(" ")
      if v.to_i == 1
        str+= " #{k} has said only#{v} recorded dumb thing\n"
      else
        str+= " #{k} has said#{v} recorded dumb things\n"
      end
    end
    str = str.delete_suffix "\n"
    bot.send_message chat_id: chat["id"], text: "There are #{Quote.count} quotes of which:\n#{str}"
  end
  def gamenew!(*args)
    TelegramUser.all.each do |t|
      t.answered = false
      t.save
    end   
    ids = Quote.all.pluck(:id)
    q = rand(ids.count)
    chosen = Quote.find_by(id: ids[q])
    sayers = Quote.all.pluck(:said_by)
    sayers = sayers.uniq
    answers = Array.new
    3.times do
      randomizer = rand(sayers.count) 
      answers<<sayers[randomizer]
      sayers.delete_at(randomizer)
    end
    answers<<chosen.said_by
    answers = answers.uniq
    if answers.count < 4
      randomizer = rand(sayers.count) 
      answers<<sayers[randomizer]
      sayers.delete_at(randomizer)
    end
    answers = answers.shuffle
      bot.send_message chat_id:chat["id"], text: "Random quote:\n#{chosen.quote} - added by: #{chosen.added_by}\nWho said it?\nAnswers:", reply_markup: {
      inline_keyboard: [
        [
          {text: "A: #{answers[0]}", callback_data: "#{check(answers[0],chosen.said_by, from["username"])}"},
          {text: "B: #{answers[1]}", callback_data: "#{check(answers[1],chosen.said_by, from["username"])}"},
        ],
        [
          {text: "C: #{answers[2]}", callback_data: "#{check(answers[2],chosen.said_by, from["username"])}"},
          {text: "D: #{answers[3]}", callback_data: "#{check(answers[3],chosen.said_by, from["username"])}"},
        ],
      ],
    }
  end
 private

  def action_missing(*)
    if update["message"]!=nil
      if update["message"]["entities"] != nil
        if update["message"]["entities"][0]["type"]=="bot_command"
          bot.send_message chat_id: chat["id"], text: "Unknown command. Please type /help to see all available commands!"
        end
      end
    end
  end
end
