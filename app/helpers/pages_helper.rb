module PagesHelper

    #funzione per prendere la posizione dell'utente corrente, o da geolocalizzazione o da ip
    def getLocation
        if params.has_key?(:gl)
            loc = params[:gl]

            if user_signed_in?
                current_user.position = loc
            end

            loc = loc.split(",")
            loc[0] = loc[0].to_d
            loc[1] = loc[1].to_d
            return loc

        else
            rip = request.remote_ip

            if rip == "127.0.0.1" || rip == "::1"
                return [-79.4063075, 0.3149312]     #coordinate Geocoder dell'Antartide
                #return [41.8933203, 12.4829321]    #coordinate Geocoder di Roma (Italia)
            else
                loc = Geocoder.search(rip)

                if loc != [] && loc.first.coordinates != [] && !loc.first.data["error"].nil?
                    loc = loc.first.coordinates

                    if user_signed_in?
                        current_user.position = "#{loc[0]},#{loc[1]}"
                    end

                    return loc
                else
                    render_500
                end
            end
        end
    end


    #funzione per prendere la lista di eventi da smistare
    def pagesAux(titolo, tag)
        if tag.nil?
            if titolo.nil?
                Event.all
            else
                Event.where("title ~* ?", titolo)
            end
        else
            if titolo.nil?
                Event.joins("JOIN has_tags ON events.id = has_tags.event_id JOIN tags ON has_tags.tag_id = tags.id AND tags.name = '#{tag}'")
            else
                Event.joins("JOIN has_tags ON events.id = has_tags.event_id JOIN tags ON has_tags.tag_id = tags.id AND tags.name = '#{tag}'").where("title ~* ?", titolo)
            end
        end
    end


    #funzione per smistare ordinatamente gli eventi in base agli input forniti
    def pagesGeneral(titolo, tag, dove, quando, qualiFiltri)
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

		for elem in pagesAux(titolo, tag)
			elemLoc = elem.cords.split(",")
			elemLoc[0] = elemLoc[0].to_d
			elemLoc[1] = elemLoc[1].to_d

			pagesZona(
				quando,
				dove,
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
        
        if qualiFiltri == 0
            events =
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

            return events
        elsif qualiFiltri == 1
            events =
                inZona_attivi_verificati_following +
                inZona_attivi_verificati_nonFollowing +
                inZona_attivi_nonVerificati_following +
                inZona_attivi_nonVerificati_nonFollowing +

                inZona_inattivi_verificati_following +
                inZona_inattivi_verificati_nonFollowing +
                inZona_inattivi_nonVerificati_following +
                inZona_inattivi_nonVerificati_nonFollowing;

            return events
        elsif qualiFiltri == 2
            events =
                inZona_attivi_verificati_following +
                inZona_attivi_verificati_nonFollowing +
                inZona_attivi_nonVerificati_following +
                inZona_attivi_nonVerificati_nonFollowing +

                nonInZona_attivi_verificati_following +
                nonInZona_attivi_verificati_nonFollowing +
                nonInZona_attivi_nonVerificati_following +
                nonInZona_attivi_nonVerificati_nonFollowing;

            return events
        else
            events =
                inZona_attivi_verificati_following +
                inZona_attivi_verificati_nonFollowing +
                inZona_attivi_nonVerificati_following +
                inZona_attivi_nonVerificati_nonFollowing;
            
            return events
        end
    end


    #funzione che smista l'evento in base alla posizione passata
    def pagesZona(date, loc, elemLoc, creator, event, i_a_v_f, i_a_v_nf, i_a_nv_f, i_a_nv_nf, i_i_v_f, i_i_v_nf, i_i_nv_f, i_i_nv_nf, n_a_v_f, n_a_v_nf, n_a_nv_f, n_a_nv_nf, n_i_v_f, n_i_v_nf, n_i_nv_f, n_i_nv_nf)
        #usato come metro di paragone la distanza in coordinate tra il centro di Roma e la "Nuova Fiera di Roma"
        if ( (elemLoc[0] - loc[0]).abs() <= 0.9 ) && ( (elemLoc[1] - loc[1]).abs() <= 0.16 )
            if date.nil?
                pagesActive(creator, event, i_a_v_f, i_a_v_nf, i_a_nv_f, i_a_nv_nf, i_i_v_f, i_i_v_nf, i_i_nv_f, i_i_nv_nf)
            else
                pagesDate(date, creator, event, i_a_v_f, i_a_v_nf, i_a_nv_f, i_a_nv_nf, i_i_v_f, i_i_v_nf, i_i_nv_f, i_i_nv_nf)
            end

        else
            if date.nil?
                pagesActive(creator, event, n_a_v_f, n_a_v_nf, n_a_nv_f, n_a_nv_nf, n_i_v_f, n_i_v_nf, n_i_nv_f, n_i_nv_nf)
            else
                pagesDate(date, creator, event, n_a_v_f, n_a_v_nf, n_a_nv_f, n_a_nv_nf, n_i_v_f, n_i_v_nf, n_i_nv_f, n_i_nv_nf)
            end
        end
    end


    #funzione che smista l'evento in base alla sua data di fine
    def pagesActive(creator, event, a_v_f, a_v_nf, a_nv_f, a_nv_nf, i_v_f, i_v_nf, i_nv_f, i_nv_nf)
        if event.end >= DateTime.now
            pagesVerification(creator, event, a_v_f, a_v_nf, a_nv_f, a_nv_nf)
        else
            pagesVerification(creator, event, i_v_f, i_v_nf, i_nv_f, i_nv_nf)
        end
    end


    #funzione che smista l'evento in base alla sua data di inizio rispetto a quella cercata
    def pagesDate(date, creator, event, a_v_f, a_v_nf, a_nv_f, a_nv_nf, i_v_f, i_v_nf, i_nv_f, i_nv_nf)
        if event.start <= date + 1 && event.start >= date - 1
            pagesVerification(creator, event, a_v_f, a_v_nf, a_nv_f, a_nv_nf)
        else
            pagesVerification(creator, event, i_v_f, i_v_nf, i_nv_f, i_nv_nf)
        end
    end


    #funzione che smista l'evento in base alla verificazione dell'autore
    def pagesVerification(creator, event, v_f, v_nf, nv_f, nv_nf)
        if creator.verification
            pagesFollowing(creator, event, v_f, v_nf)
        else
            pagesFollowing(creator, event, nv_f, nv_nf)
        end
    end


    #funzione che smista l'evento in base al following dell'utente corrente (se è un visitatore manda tutto in nf)
    def pagesFollowing(creator, event, f, nf)
        if !user_signed_in?
            nf << event
        elsif Follow.where(followed_id: creator.id, follower_id: current_user.id).length > 0
            f << event
        elsif HasTag.joins("JOIN follows_tags ON has_tags.tag_id = follows_tags.tag_id AND follows_tags.user_id = #{current_user.id} AND has_tags.event_id = #{event.id}").length > 0
            f << event
        else
            nf << event
        end
    end


    #funzione per la ricerca di utenti
    def searchUsers(ricerca)
        verificati_following = []
        verificati_nonFollowing = []
        nonVerificati_following = []
        nonVerificati_nonFollowing = []

        for elem in User.all
            if elem.username.downcase.strip.include?(ricerca)
                if elem.verification
                    if user_signed_in? && Follow.where(follower_id: current_user.id, followed_id: elem.id).length > 0
                        verificati_following << elem
                    else
                        verificati_nonFollowing << elem
                    end

                else
                    if user_signed_in? && Follow.where(follower_id: current_user.id, followed_id: elem.id).length > 0
                        nonVerificati_following << elem
                    else
                        nonVerificati_nonFollowing << elem
                    end
                end
            end
        end

        users = verificati_following + verificati_nonFollowing + nonVerificati_following + nonVerificati_nonFollowing
        return users
    end


    #funzione per la ricerca di tag (ed eventi correlati)
    def searchTags(ricerca, dove, quando, qualiFiltri)
        tags = Tag.where("name ~* ?", ricerca[1, ricerca.length-1])
        events = pagesGeneral(nil, ricerca, dove, quando, qualiFiltri)
        return { tags: tags, events: events }
    end

end
