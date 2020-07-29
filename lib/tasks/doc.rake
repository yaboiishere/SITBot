require "google/cloud/storage"
desc "check for new docs"
task :doc => :environment do
	Newquote.all.delete_all
    service = Google::Apis::DocsV1::DocsService.new
    service.client_options.application_name = "My Project"
    service.authorization =  ApplicationHelper.authorize
    file1 = File.open("token.yaml", "w")
    file1.write "placeholder text lol"
    file1.close
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
        if d.paragraph.elements[0].text_run.content == "Distinguishing mark to separate names from doc change something and i’ll kill you"
          participants = true
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
                    Newquote.where(quote: str, said_by: l, added_by: adder).first_or_create
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
              Newquote.where(quote: cnt, said_by: "Krefa", added_by: adder).first_or_create
              whole+=str
              wholearr << str
              str = ""
            end
          end
        else
          if d.paragraph.elements[0].text_run.content != "Participants:"
            col = String.new
            col = d.paragraph.elements[0].text_run.text_style.foreground_color.color.rgb_color.to_h rescue ""
            col = col.to_s
            col = col.delete("{")
            col = col.delete("}")
            name = d.paragraph.elements[0].text_run.content.delete_suffix("\n")
            Color.where(by: name, rgb: col).first_or_create
          end
        end
      end
    itermm=itermm+1
    end
    newQuotes = Array.new
    oldQuotes = Array.new
    Newquote.all.each do |n|
    	newQuotes << "#{n.quote} - said by: #{n.said_by} - added by: #{n.added_by}\n"
    end
    Quote.all.each do |q|
    	oldQuotes << "#{q.quote} - said by: #{q.said_by} - added by: #{q.added_by}\n"
    end
    if newQuotes.count - oldQuotes.count > 0
    	puts newQuotes
    	str = "New quotes:\n"
    	newQuotes = newQuotes - oldQuotes
    	newQuotes = newQuotes.uniq
    	newQuotes.each do |n|
    		str += "#{n}"
    	end
    	Telegram::bot.send_message chat_id: -1001270079964, text: str
    	Telegram::bot.send_message chat_id: -1001473157732, text: str

    else
    	puts "no new quotes"
    end
    # service = Google::Apis::DocsV1::DocsService.new
    # service.client_options.application_name = "My Project"
    # service.authorization = authorize
    # document_id = "1kCpbvzJKeZ2dfKn97DmXuseRBo1QNSm0LCJui7iW7kY"
    # document = service.get_document document_id
    itermm = 0
    str =String.new
    whole = ""
    wholearr = Array.new
    color = Array.new
    krefa = false
    participants = false
    document.body.content.each do |d|
      if d.paragraph != nil
        if d.paragraph.elements[0].text_run.content == "Distinguishing mark to separate names from doc change something and i’ll kill you"
          participants = true
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
          if d.paragraph.elements[0].text_run.content != "Participants:"
            col = String.new
            col = d.paragraph.elements[0].text_run.text_style.foreground_color.color.rgb_color.to_h rescue ""
            col = col.to_s
            col = col.delete("{")
            col = col.delete("}")
            name = d.paragraph.elements[0].text_run.content.delete_suffix("\n")
            Color.where(by: name, rgb: col).first_or_create
          end
        end
      end
    itermm=itermm+1
    end
    file1 = File.open("token.yaml", "w")
    file1.write "placeholder text lol"
    file1.close
end
