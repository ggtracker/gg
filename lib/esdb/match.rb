module ESDB
  class Match < ESDB::Resource

    # Does the match have any summary data?
    def summaries?
      hash = self.to_hash
      if hash['entities'].any?
        summaries = hash['entities'].collect{|e| e['summary']}
        return summaries.reject{|s| s.nil? || s.empty?}.any?
      end
      false
    end

    # Does the match have replays?
    def replays?
      self.replays_count && self.replays_count > 0
    end

    def map
      Hashie::Mash.new(self.to_hash['map'])
    end

    def replays
      self.to_hash['replays'].collect{|replay| Hashie::Mash.new(replay)}
    end

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

    def userdelete(user_id)
      resp = RestClient.post(url + '/userdelete', :access_token => ESDB.api_key, :user_id => user_id)
      JSON.parse(resp)
    end

    def expansion
      (release_string && release_string[0] == '2' && release_string != '2.0.4.24944') ? 'HotS' : 'WoL'
    end

    def expansion_long
      expansion == 'HotS' ? 'Heart of the Swarm' : 'Wings of Liberty'
    end
  end
end
