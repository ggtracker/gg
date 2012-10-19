module ESDB
  class Match < ESDB::Resource
    # Combines all entities into a hash keys with the team number
    def teams
      entities.inject({}){|teams, entity| 
        teams[entity['team']] ||= []
        teams[entity['team']] << entity
        teams
      }
    end

    def duration_minutes
      return (duration_seconds / 60.0).round
    end

    # this function doesnt belong here. where does it belong?
    def smooth(indata, window_size)
      window = []
      result = []
      runningavg = 0
      for elm in indata
        elm = 0 if elm.nil?
        runningavg += elm
        window.push(elm)
        if window.length > window_size
          removedelm = window.shift
          runningavg -= removedelm
        end
        windowavg = runningavg.to_f / window.length
        result.push(windowavg.round(2))
      end
      return result
    end

    # where does this function belong?
    #
    # MR says "[if it] deals directly with data on the model, it goes in the model"
    #
    # and yet this feels suspiciously like view logic.
    #
    def chart_data(measure, smoothing_window)
      entities.collect {|entity|
        extracted_measures = []
        entity["minutes"].each {|minute, measures|
          extracted_measures[minute.to_i - 1] = measures[measure].to_f unless minute == "0"
        }
        {:name => entity["identity"]["name"],
         :data => smooth(extracted_measures, smoothing_window),
         :color => "#" + entity["color"],
         :team => entity["team"],
        }
      }
    end
  end
end
