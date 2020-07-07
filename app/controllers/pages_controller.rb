class PagesController < ApplicationController

	#GET sulla root
	def home
		@hasGL = params.has_key?(:gl)
		@events = helpers.pagesGeneral(nil, nil, helpers.getLocation, nil, nil, 0)
	end


	#GET su /search
	#Restituisce un json {"type": X, "content": Y}
	#Con X "users", "events", "tags"
	#Con Y rispettivamente la lista di utenti, eventi e un json { "tags": lista_tags, "events": lista_events_tags }
	def search
		@hasGL = params.has_key?(:gl)

		if !params.has_key?(:q) || params[:q].nil?
			@risposta = { type: "events", content: helpers.pagesGeneral(nil, nil, helpers.getLocation, nil, nil, 0) }

		else
			ricerca = params[:q].downcase.strip
			qualiFiltri = 0
	
			if params.has_key?(:w)
				dove = params[:w]
	
				if dove.match?(/^[-+]?([1-8]?\d(\.\d+)?|90(\.0+)?),[-+]?(180(\.0+)?|((1[0-7]\d)|([1-9]?\d))(\.\d+)?)$/)
					@w = dove
					@p = params[:p]
					dove = dove.split(",")
					dove[0] = dove[0].to_d
					dove[1] = dove[1].to_d
					qualiFiltri += 1
				else
					dove = helpers.getLocation
				end
			else
				dove = helpers.getLocation
			end
	
			if params.has_key?(:es) && params.has_key?(:ee)
				begin
					@es = params[:es]
					@ee = params[:ee]
					inizio = params[:es].to_datetime
					fine = params[:ee].to_datetime
					qualiFiltri += 2
				rescue ArgumentError
					inizio = nil
					fine = nil
				end			
			else
				inizio = nil
				fine = nil
			end
			
			#cerco utenti
			if ricerca[0] == "@"
				@risposta = { type: "users", content: helpers.searchUsers(ricerca[1, ricerca.length-1]) }
	
			#cerco tag (e corrispettivi eventi)
			elsif ricerca[0] == "#"
				@risposta = { type: "tags", content: helpers.searchTags(ricerca, dove, inizio, fine, qualiFiltri) }
	
			#cerco eventi
			else
				@risposta = { type: "events", content: helpers.pagesGeneral(ricerca, nil, dove, inizio, fine, qualiFiltri) }
			end
		end
	end


	#GET su /about-us
	def aboutus
		@admins = User.where(admin: true)
	end
end
