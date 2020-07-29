class GifgetterController < ApplicationController
	require "google/cloud/storage"



	def gifchecker
		storage = Google::Cloud::Storage.new project_id: Figaro.env.google_project_id, credentials: JSON.parse(Figaro.env.GOOGLE_APPLICATION_CREDENTIALS)
		bucket = storage.bucket "pgebot_storage"
		breaker = false
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

		redirect_to root_path
	end

end
