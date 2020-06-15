module EventsHelper

    #Funzione usata per prendere la stringa dei tag, raccogliere quelli validi ed aggiungerli se già non esistono
    def createTags(t)
        tags = t.scan(/#\w+/).flatten.map(&:downcase).uniq
                
        for elem in tags
            tg = Tag.where(name: elem)[0]

            if tg.nil?   
                tg = Tag.new(name: elem)

                if tg.valid?
                    if ! tg.save
                        render_500
                    end
                else
                    render_400
                end
            end
        end

        return tags
    end


    #Funzione usata per creare il collegamento tra evento e tag se già non esiste
    def createHasTags(tags, event)                 
        for elem in tags
            tg = Tag.where(name: elem)[0]

            if tg.nil?   
                render_400
            else
                tg = HasTag.new(event_id: event.id, tag_id: tg.id)

                if tg.valid?
                    if ! tg.save
                        render_500
                    end
                else
                    render_400
                end
            end
        end
    end


    #Funzione usata per cancellare tutti i collegamenti tra evento e tag
    def destroyHasTags(event)
        has_tags = HasTag.where(:event_id => event.id)
        for elem in has_tags
            if !elem.destroy
                render_500
            end
        end
    end

end
