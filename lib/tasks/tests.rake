namespace :test do
	pluralgeek_id = "-1001473157732"
	forwared_id = "-329128491"
	forwared_id_new = "-1001270079964"
	desc "Removes older tests"
	task :update => :environment do 
		Test.all.each do |t|
			if t.date.strftime("%Y/%m/%d")<Time.now.strftime("%Y/%m/%d")
				t.destroy
			end 
			puts Time.now.strftime("%Y/%m/%d")
		end
	end
end