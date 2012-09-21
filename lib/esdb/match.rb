module ESDB
  class Match < ESDB::Resource
    def duration_minutes
      return (duration_seconds / 60.0).round
    end

    # where does this function belong?
    #
    # MR says "[if it] deals directly with data on the model, it goes in the model"
    #
    # and yet this feels suspiciously like view logic.
    #
    def chart_data(measure)
      entities.collect {|entity|
        extracted_measures = []
        entity["minutes"].each {|minute, measures|
          extracted_measures[minute.to_i] = measures[measure].to_f
        }
        {:name => entity["identity"]["name"],
         :data => extracted_measures,
         :color => "#" + entity["color"],
        }
      }.to_json
    end
  end
end
