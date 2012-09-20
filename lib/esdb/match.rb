module ESDB
  class Match < ESDB::Resource
    def duration_minutes
      return (duration_seconds / 60.0).round
    end
  end
end
