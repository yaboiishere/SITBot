class DocsController < ApplicationController
	def update
		async_rake("doctime")
		puts "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaas"
		redirect_to root_path
	end
end
