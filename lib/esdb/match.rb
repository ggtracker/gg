module ESDB
  class Match < ESDB::Resource
    # HAX
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

    # TODO: when there is ample time, I want to generalize stuff like this via
    # something like Hashie, but Hashie::Mash just didn't work out right away
    # it's complicated.. the fact that we have a key called "map" alone..
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
  end
end
