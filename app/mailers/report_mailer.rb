class ReportMailer < ApplicationMailer

    #Funzione per calcolare la distanza in metri fra due coordinate
    def distance(loc1, loc2)
        rad_per_deg = Math::PI/180
        rkm = 6371
        rm = rkm * 1000
      
        dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg
        dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg
      
        lat1_rad = loc1.map {|i| i * rad_per_deg }.first
        lat2_rad = loc2.map {|i| i * rad_per_deg }.first
      
        a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
        c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
      
        return rm * c
    end


    #Funzione per calcolare gli hot events (tiene da conto principalmente posizione e following)
    def takeHotEvents(user)
        hot_events = []

        inZona_following = []
        inZona_nonFollowing = []
        nonInZona_following = []
        nonInZona_nonFollowing = []

        userLoc = nil
        if user.position != ""
            userLoc = user.position.split(",")
            userLoc[0] = userLoc[0].to_d
            userLoc[1] = userLoc[1].to_d
        end

        for elem in Event.all
            elemLoc = elem.cords.split(",")
			elemLoc[0] = elemLoc[0].to_d
            elemLoc[1] = elemLoc[1].to_d

            if elem.end >= DateTime.now && elem.start <= (DateTime.now + 7)
                if userLoc.nil? || distance(elemLoc, userLoc) > 20000
                    if (Follow.where(followed_id: elem.user_id, follower_id: user.id).length > 0 ||
                        HasTag.joins("JOIN follows_tags ON has_tags.tag_id = follows_tags.tag_id AND follows_tags.user_id = #{user.id} AND has_tags.event_id = #{elem.id}").length > 0)
                        nonInZona_following << elem
                    else
                        nonInZona_nonFollowing << elem
                    end

                else
                    if (Follow.where(followed_id: elem.user_id, follower_id: user.id).length > 0 ||
                        HasTag.joins("JOIN follows_tags ON has_tags.tag_id = follows_tags.tag_id AND follows_tags.user_id = #{user.id} AND has_tags.event_id = #{elem.id}").length > 0)
                        inZona_following << elem
                    else
                        inZona_nonFollowing << elem
                    end
                end
            end
        end

        hot_events = inZona_following

        if hot_events.length < 10
            hot_events += inZona_nonFollowing

            if hot_events.length < 10
                hot_events += nonInZona_following

                if hot_events.length < 10

                    if nonInZona_nonFollowing.length < 10 - hot_events.length
                        hot_events += nonInZona_nonFollowing
                    else
                        while hot_events.length < 10
                            hot_events << nonInZona_nonFollowing.shift
                        end
                    end     
                end
            end
        end

        return hot_events
    end


    #Invia una mail di resoconto settimanale all'utente (in congiunzione con whenever)
    def send_report_email(user)
        @user = user
        @going = Event.joins("JOIN participations ON participations.user_id = #{@user.id} AND events.id = participations.event_id AND participations.value = 'p' AND events.end >= '#{DateTime.now}'")
        @interested = Event.joins("JOIN participations ON participations.user_id = #{@user.id} AND events.id = participations.event_id AND participations.value = 'i' AND events.end >= '#{DateTime.now}'")
        @hot_events = takeHotEvents(@user)

        mail(to: @user.email, subject: 'Your weekly ACARA report is here!') #:from => "team@acara.it"
    end

end
