module ESDB
  class Identity < ESDB::Resource
    def to_hash
      get! unless @response
      hash = JSON.parse(@response)

      Rails.logger.info hash.inspect

      # Only include stats for ourself.
      hash['stats'] = hash['stats'][hash['id'].to_s] if hash['stats']
      hash
    end
  end
end
