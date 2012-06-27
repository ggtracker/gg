module ESDB
  # Simply transforms a stats hash into a StatsParam string
  class StatsParam
    def initialize(stats)
      @array = []
      @stats = stats
      stats.each do |key, value|
        if value.is_a?(Array)
          values = value.join(',')
        elsif value === true
          values = 'avg'
        else
          values = value
        end

        @array << "#{key}(#{values})"
      end
    end

    def to_s
      @array.join(',')
    end
  end
end

require 'lib/esdb/resource'
require 'lib/esdb/identity'
require 'lib/esdb/stat'
