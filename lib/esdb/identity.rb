module ESDB
  class Identity < ESDB::Resource
    def to_hash
      get! unless @response
      hash = JSON.parse(@response)

      # Only include stats for ourself.
      hash['stats'] = hash['stats'][hash['id'].to_s] if hash['stats']
      hash
    end

    def sc2ranks_url
      "http://sc2ranks.com/#{gateway}/#{bnet_id}/#{name}"
    end
  end
end
