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
			elemLoc[1] = elemLoc[1].split[0].to_d

			creator = User.find(elem.user_id)

			helpers.homeZona(
				helpers.getLocation,
				elemLoc,
				creator,
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
		# following = params[:following]
		# distanza = params[:distanza]
		# data = params[:data]
		# verificati = params[:verificati]

		# if following == 1
		# 	if distanza == 1
		# 		if data == 1
		# 			if verificati == 1
						
		# 			end
		# 		end
		# 	end

		# elsif distanza == 1
		# 	if data == 1
		# 		if verificati == 1
					
		# 		end
		# 	end

		# elsif data == 1
		# 	if verificati == 1
				
		# 	end

		# elsif verificati == 1
		# 	@events = Event.joins("JOIN users ON users.verification").where("title ~* ?", ricerca)
		
		# else
		# 	@events = Event.where("title ~* ?", ricerca)
		# 	@users = User.where("username ~* ?", ricerca)
		# 	@tags = Tag.where("name ~* ?", ricerca)
		# end
	end

end
