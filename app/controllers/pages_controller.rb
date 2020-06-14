class PagesController < ApplicationController

	#GET sulla root
	def home
		inZona_attivi_verificati_following = []
		inZona_attivi_verificati_nonFollowing = []
		inZona_attivi_nonVerificati_following = []
		inZona_attivi_nonVerificati_nonFollowing = []

		inZona_inattivi_verificati_following = []
		inZona_inattivi_verificati_nonFollowing = []
		inZona_inattivi_nonVerificati_following = []
		inZona_inattivi_nonVerificati_nonFollowing = []

		nonInZona_attivi_verificati_following = []
		nonInZona_attivi_verificati_nonFollowing = []
		nonInZona_attivi_nonVerificati_following = []
		nonInZona_attivi_nonVerificati_nonFollowing = []

		nonInZona_inattivi_verificati_following = []
		nonInZona_inattivi_verificati_nonFollowing = []
		nonInZona_inattivi_nonVerificati_following = []
		nonInZona_inattivi_nonVerificati_nonFollowing = []

		for elem in Event.all
			elemLoc = elem.cords.split(",")
			elemLoc[0] = elemLoc[0].to_d
			elemLoc[1] = elemLoc[1].strip.to_d

			helpers.homeZona(
				nil,
				helpers.getLocation,
				elemLoc,
				User.find(elem.user_id),
				elem,
				inZona_attivi_verificati_following,
				inZona_attivi_verificati_nonFollowing,
				inZona_attivi_nonVerificati_following,
				inZona_attivi_nonVerificati_nonFollowing,
				inZona_inattivi_verificati_following,
				inZona_inattivi_verificati_nonFollowing,
				inZona_inattivi_nonVerificati_following,
				inZona_inattivi_nonVerificati_nonFollowing,
				nonInZona_attivi_verificati_following,
				nonInZona_attivi_verificati_nonFollowing,
				nonInZona_attivi_nonVerificati_following,
				nonInZona_attivi_nonVerificati_nonFollowing,
				nonInZona_inattivi_verificati_following,
				nonInZona_inattivi_verificati_nonFollowing,
				nonInZona_inattivi_nonVerificati_following,
				nonInZona_inattivi_nonVerificati_nonFollowing
			)
		end

		@events =
			inZona_attivi_verificati_following +
			inZona_attivi_verificati_nonFollowing +
			inZona_attivi_nonVerificati_following +
			inZona_attivi_nonVerificati_nonFollowing +

			inZona_inattivi_verificati_following +
			inZona_inattivi_verificati_nonFollowing +
			inZona_inattivi_nonVerificati_following +
			inZona_inattivi_nonVerificati_nonFollowing +

			nonInZona_attivi_verificati_following +
			nonInZona_attivi_verificati_nonFollowing +
			nonInZona_attivi_nonVerificati_following +
			nonInZona_attivi_nonVerificati_nonFollowing +

			nonInZona_inattivi_verificati_following +
			nonInZona_inattivi_verificati_nonFollowing +
			nonInZona_inattivi_nonVerificati_following +
			nonInZona_inattivi_nonVerificati_nonFollowing;
	end


	# TODO CERCA
	#di default come la home
	#in base a @ o # o niente davanti per cercare utenti, tag o eventi
	#filtri su data e luogo inserito (vedi gemma di prima)

  	#GET su /search
	def search
		# ricerca = params[:q]
		
		# #cerco utenti
		# if ricerca[0] == "@"
		# 	ricerca = ricerca[1, ricerca.length-1].downcase
		# 	verificati_following = []
		# 	verificati_nonFollowing = []
		# 	nonVerificati_following = []
		# 	nonVerificati_nonFollowing = []

		# 	for elem in User.all
		# 		if elem.username.downcase.include?(ricerca)
		# 			if elem.verification
		# 				if Follow.where(follower_id: current_user.id, followed_id: elem.id)
		# 					verificati_following << elem
		# 				else
		# 					verificati_nonFollowing << elem
		# 				end
	
		# 			else
		# 				if Follow.where(follower_id: current_user.id, followed_id: elem.id)
		# 					nonVerificati_following << elem
		# 				else
		# 					nonVerificati_nonFollowing << elem
		# 				end
		# 			end
		# 		end
		# 	end

		# 	@risposta = { "type": "users", "content": verificati_following + verificati_nonFollowing + nonVerificati_following + nonVerificati_nonFollowing }

		# #cerco tag
		# elsif ricerca[0] == "#"
		# 	ricerca = ricerca[1, ricerca.length-1].downcase
		# 	@risposta = { "type": "tags", "content": Tag.where("name ~* ?", ricerca) }

		# #cerco eventi
		# else
		# 	if params.has_key?(:dove)
		# 		dove = params[:dove]
		# 	else
		# 		dove = helpers.getLocation
		# 	end

		# 	if params.has_key?(:dove)
		# 		quando = params[:quando].to_datetime
		# 	end




		# 	inZona_attivi_verificati_following = []
		# 	inZona_attivi_verificati_nonFollowing = []
		# 	inZona_attivi_nonVerificati_following = []
		# 	inZona_attivi_nonVerificati_nonFollowing = []

		# 	inZona_inattivi_verificati_following = []
		# 	inZona_inattivi_verificati_nonFollowing = []
		# 	inZona_inattivi_nonVerificati_following = []
		# 	inZona_inattivi_nonVerificati_nonFollowing = []

		# 	nonInZona_attivi_verificati_following = []
		# 	nonInZona_attivi_verificati_nonFollowing = []
		# 	nonInZona_attivi_nonVerificati_following = []
		# 	nonInZona_attivi_nonVerificati_nonFollowing = []

		# 	nonInZona_inattivi_verificati_following = []
		# 	nonInZona_inattivi_verificati_nonFollowing = []
		# 	nonInZona_inattivi_nonVerificati_following = []
		# 	nonInZona_inattivi_nonVerificati_nonFollowing = []


			

		# 	for elem in Event.all
		# 		elemLoc = elem.cords.split(",")
		# 		elemLoc[0] = elemLoc[0].to_d
		# 		elemLoc[1] = elemLoc[1].strip.to_d

		# 		helpers.homeZona(
		# 			dove,
		# 			elemLoc,
		# 			User.find(elem.user_id),
		# 			elem,
		# 			inZona_attivi_verificati_following,
		# 			inZona_attivi_verificati_nonFollowing,
		# 			inZona_attivi_nonVerificati_following,
		# 			inZona_attivi_nonVerificati_nonFollowing,
		# 			inZona_inattivi_verificati_following,
		# 			inZona_inattivi_verificati_nonFollowing,
		# 			inZona_inattivi_nonVerificati_following,
		# 			inZona_inattivi_nonVerificati_nonFollowing,
		# 			nonInZona_attivi_verificati_following,
		# 			nonInZona_attivi_verificati_nonFollowing,
		# 			nonInZona_attivi_nonVerificati_following,
		# 			nonInZona_attivi_nonVerificati_nonFollowing,
		# 			nonInZona_inattivi_verificati_following,
		# 			nonInZona_inattivi_verificati_nonFollowing,
		# 			nonInZona_inattivi_nonVerificati_following,
		# 			nonInZona_inattivi_nonVerificati_nonFollowing
		# 		)
		# 	end

		# 	@events =
		# 		inZona_attivi_verificati_following +
		# 		inZona_attivi_verificati_nonFollowing +
		# 		inZona_attivi_nonVerificati_following +
		# 		inZona_attivi_nonVerificati_nonFollowing +

		# 		inZona_inattivi_verificati_following +
		# 		inZona_inattivi_verificati_nonFollowing +
		# 		inZona_inattivi_nonVerificati_following +
		# 		inZona_inattivi_nonVerificati_nonFollowing +

		# 		nonInZona_attivi_verificati_following +
		# 		nonInZona_attivi_verificati_nonFollowing +
		# 		nonInZona_attivi_nonVerificati_following +
		# 		nonInZona_attivi_nonVerificati_nonFollowing +

		# 		nonInZona_inattivi_verificati_following +
		# 		nonInZona_inattivi_verificati_nonFollowing +
		# 		nonInZona_inattivi_nonVerificati_following +
		# 		nonInZona_inattivi_nonVerificati_nonFollowing;
		# 	end



		#restituisce un json {"type": X, "content": Y}
		#con X "users", "tags", "events"
		#con Y la lista di cose restituite

		
		#@events = Event.joins("JOIN users ON users.verification").where("title ~* ?", ricerca)
		
		# else
		# 	@events = Event.where("title ~* ?", ricerca)
		# 	@users = User.where("username ~* ?", ricerca)
		# 	@tags = Tag.where("name ~* ?", ricerca)
		# end
	end

end
