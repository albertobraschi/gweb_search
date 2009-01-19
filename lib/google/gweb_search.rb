# -*- mode:ruby; coding:utf-8 -*-

require 'rubygems'
require 'net/http'
require 'json'
require 'cgi'

module Google
  module GwebSearch
    VERSION = '1.0.0'
    API_URL = 'http://www.google.com/uds/GwebSearch'

    class RequestError < StandardError; end

    @@options = {
      :lstkp => 0,
      :context => 0,
      :rsz => 'small',
      :hl => 'ja',
      :v => '0.1'
    }
    @@logger = nil

    class << self
      # Default search options
      def options
        @@options
      end

      # Set default search options
      def options=(opts)
        @@options = opts
      end

      # Get logger
      def logger
        @@logger
      end

      # Set logger
      def logger=(logger)
        @@logger = logger
      end

      def configure(&proc)
        raise ArgumentError, "Block is required." unless block_given?
        yield @@options
      end

      def search(query)
        opts = self.options.merge('q' => query)
        request_url = prepare_url(opts)
        logger.debug "Request URL: #{request_url}"
        res = Net::HTTP.get_response(URI::parse(request_url))
        logger.debug "HTTP status: #{res.code} #{res.message}"
        unless res.kind_of? Net::HTTPSuccess
          raise RequestError, "HTTP Response: #{res.code} #{res.message}"
        end
        logger.debug "Response body: #{res.body}"
        Response.new(res.body)
      end

      protected
      def logger
        return @@logger if @@logger
        @@null_logger ||= NullLogger.new
      end

      private
      def prepare_url(opts)
        qs = ''
        opts.each {|k,v|
          next unless v
          v = v.join(',') if v.is_a? Array
          qs << "&#{k}=#{URI.encode(v.to_s)}"
        }
        "#{API_URL}?#{qs}"
      end
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

    class NullLogger
      def method_missing(name, *args); nil; end
    end
  end
end
