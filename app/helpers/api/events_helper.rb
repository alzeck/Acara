module Api::EventsHelper

    #Funzione usata per vedere che vengano passati tutti i parametri alla api per funzionare
    def hasAll(par)
        if (
            par[:title].present? &&
            par[:description].present? &&
            par[:start].present? &&
            par[:end].present? &&
            par[:where].present? &&
            par[:cords].present? &&
            (par[:tags].is_a? String)
        )
            return true
        else
            return false
        end
    end

end
