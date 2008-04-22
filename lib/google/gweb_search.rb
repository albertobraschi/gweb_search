require 'net/http'
require 'json'
require 'cgi'

module Google
  class RequestError < StandardError; end

  class GwebSearch
    API_URL = 'http://www.google.com/uds/GwebSearch'

    @@options = {
      :lstkp => 0,
      :context => 0,
      :rsz => 'small',
      :hl => 'ja',
      :v => '0.1'
    }
    @@debug = false
    
    # Default search options
    def self.options
      @@options
    end
    
    # Set default search options
    def self.options=(opts)
      @@options = opts
    end
    
    # Get debug flag.
    def self.debug
      @@debug
    end
    
    # Set debug flag to true or false.
    def self.debug=(dbg)
      @@debug = dbg
    end
    
    def self.configure(&proc)
      raise ArgumentError, "Block is required." unless block_given?
      yield @@options
    end

    def self.search(query)
      opts = self.options.merge('q' => query)
      request_url = prepare_url(opts)
      log "Request URL: #{request_url}"
      
      res = Net::HTTP.get_response(URI::parse(request_url))
      unless res.kind_of? Net::HTTPSuccess
        raise Google::RequestError, "HTTP Response: #{res.code} #{res.message}"
      end
      Response.new(res.body)
    end
    
    class Response
      def initialize(json)
        @json = json
      end
      
      attr_reader :json
      
      def parsed_response
        @parsed_response ||= JSON.parse(@json)
      end

      def results
        parsed_response['responseData']['results'] rescue []
      end

      def details
        parsed_response['responseDetails']
      end
      
      def status
        parsed_response['responseStatus']
      end
    end
    
    protected
    def self.log(s)
      return unless self.debug
      if defined? RAILS_DEFAULT_LOGGER
        RAILS_DEFAULT_LOGGER.error(s)
      elsif defined? LOGGER
        LOGGER.error(s)
      else
        puts s
      end
    end

    private 
    def self.prepare_url(opts)
      qs = ''
      opts.each {|k,v|
        next unless v
        v = v.join(',') if v.is_a? Array
        qs << "&#{k}=#{URI.encode(v.to_s)}"
      }
      "#{API_URL}?#{qs}"
    end
  end
end


# debug
if __FILE__ == $0
  require 'pp'
  api_key = File.open("#{ENV['HOME']}/.google_key") {|fh| fh.read }.strip
  Google::GwebSearch.debug = true
  Google::GwebSearch.options[:key] = api_key
  res = Google::GwebSearch.search('Squarepusher Hardcore Obelisk site:amazon.co.jp')
  pp res.parsed_response
  res.results.each do |r|
    puts r['unescapedUrl']
  end
end
