module ESDB
  class Identity < ESDB::Resource
    def to_hash
      get! unless @response
      hash = JSON.parse(@response)

      # Only include stats for ourself.
      hash['stats'] = hash['stats'][hash['id'].to_s]
      hash
    end
  end
end
