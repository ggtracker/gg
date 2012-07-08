module ESDB
  class Resource < RestClient::Resource
    attr_accessor :params

    def initialize(url=nil, options={}, *args)
      options[:headers] ||= {}

      # Lets you specify options, finder-like, as the first argument:
      # Resource.new(:id => 123)
      if url.is_a?(Hash)
        options[:headers][:params] ||= {}
        options[:headers][:params].merge!(url)
        url = nil
      end

      # REST is DRY! Let's just guess our url..
      klass_ep = self.class.to_s.scan(/::(.*?)$/).flatten[0].pluralize.underscore
      @url ||= "http://localhost:9292/api/v1/#{klass_ep}"

      # For now, various params will trigger a change in the URI
      # might want to do it more like Rails in esdb ..not sure yet
      @params = options[:headers][:params]
      if @params.any?
        @url += "/#{@params.delete(:id)}" if @params[:id]
        options[:headers][:params][:stats] = StatsParam.new(options[:headers][:params][:stats]) if @params[:stats]
      end

      # And we also default to JSON
      options[:headers][:accept] ||= 'application/json'

      @options = options
      # Screw super, there's nothing useful in it anyway.
      # https://github.com/archiloque/rest-client/blob/master/lib/restclient/resource.rb#L39
      # super(url, *args)
    end

    # Retrieves the resource and unlike RestClient, stores the result in the
    # instance instead of returning it (but also returns it)
    def get!(*args)
      @response = get(*args)
    end

    def to_hash
      get! unless @response
      JSON.parse(@response)
    end
  end
end