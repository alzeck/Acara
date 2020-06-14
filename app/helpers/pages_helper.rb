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


    #funzione che smista l'evento in base alla posizione dell'utente corrente
    def homeZona(date, loc, elemLoc, creator, event, i_a_v_f, i_a_v_nf, i_a_nv_f, i_a_nv_nf, i_i_v_f, i_i_v_nf, i_i_nv_f, i_i_nv_nf, n_a_v_f, n_a_v_nf, n_a_nv_f, n_a_nv_nf, n_i_v_f, n_i_v_nf, n_i_nv_f, n_i_nv_nf)
        #usato come metro di paragone la distanza in coordinate tra il centro di Roma e la "Nuova Fiera di Roma"
        if ( (elemLoc[0] - loc[0]).abs() <= 0.9 ) && ( (elemLoc[1] - loc[1]).abs() <= 0.16 )
            if date.nil?
                homeActive(creator, event, i_a_v_f, i_a_v_nf, i_a_nv_f, i_a_nv_nf, i_i_v_f, i_i_v_nf, i_i_nv_f, i_i_nv_nf)
            else
                homeDate(date, creator, event, i_a_v_f, i_a_v_nf, i_a_nv_f, i_a_nv_nf, i_i_v_f, i_i_v_nf, i_i_nv_f, i_i_nv_nf)
            end

        else
            if date.nil?
                homeActive(creator, event, n_a_v_f, n_a_v_nf, n_a_nv_f, n_a_nv_nf, n_i_v_f, n_i_v_nf, n_i_nv_f, n_i_nv_nf)
            else
                homeDate(date, creator, event, n_a_v_f, n_a_v_nf, n_a_nv_f, n_a_nv_nf, n_i_v_f, n_i_v_nf, n_i_nv_f, n_i_nv_nf)
            end
        end
    end


    #funzione che smista l'evento in base alla sua data di fine
    def homeActive(creator, event, a_v_f, a_v_nf, a_nv_f, a_nv_nf, i_v_f, i_v_nf, i_nv_f, i_nv_nf)
        if event.end >= DateTime.now
            homeVerification(creator, event, a_v_f, a_v_nf, a_nv_f, a_nv_nf)
        else
            homeVerification(creator, event, i_v_f, i_v_nf, i_nv_f, i_nv_nf)
        end
    end


    #funzione che smista l'evento in base alla sua data di inizio rispetto a quella cercata
    def homeDate(date, creator, event, a_v_f, a_v_nf, a_nv_f, a_nv_nf, i_v_f, i_v_nf, i_nv_f, i_nv_nf)
        if event.start <= date + 1 || event.start >= date - 1
            homeVerification(creator, event, a_v_f, a_v_nf, a_nv_f, a_nv_nf)
        else
            homeVerification(creator, event, i_v_f, i_v_nf, i_nv_f, i_nv_nf)
        end
    end


    #funzione che smista l'evento in base alla verificazione dell'autore
    def homeVerification(creator, event, v_f, v_nf, nv_f, nv_nf)
        if creator.verification
            homeFollowing(creator, event, v_f, v_nf)
        else
            homeFollowing(creator, event, nv_f, nv_nf)
        end
    end


    #funzione che smista l'evento in base al following dell'utente corrente (se è un visitatore manda tutto in nf)
    def homeFollowing(creator, event, f, nf)
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

end
