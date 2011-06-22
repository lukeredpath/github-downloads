require 'restclient'
require 'ostruct'

module Github
  class Client
    class << self
      def connect(base_url)
        new RestClient::Resource.new(base_url)
      end
    end
    
    def initialize(resource)
      @resource = resource
    end
    
    def get(path)
      Response.new(@resource[path].get)
    rescue RestClient::Exception => e
      Response.new(e.response)
    end
    
    def post(path, data)
      Response.new(@resource[path].post(data.to_json))
    rescue RestClient::Exception => e
      Response.new(e.response)
    end
    
    class Response
      def initialize(response)
        @response = response
      end
      
      def to_s
        "#{@response.description} | Rate limit: #{rate_limit_remaining} / #{rate_limit_remaining}"
      end
      
      def success?
        when_statuses_are 200, 201
      end
      
      def error?
        when_statuses_are 400, 422
      end
      
      def error_message
        parsed_response["message"]
      end
      
      def errors
        parsed_response["errors"].map { |hash| EntityError.new(hash) }
      end
      
      def rate_limit
        @response.headers[:x_ratelimit_limit].to_i
      end
      
      def rate_limit_remaining
        @response.headers[:x_ratelimit_remaining].to_i
      end
      
      def location
        @response.headers[:location]
      end
      
      def data
        parsed_response
      end
      
      private
      
      def parsed_response
        @parsed_response ||= JSON.parse(@response)
      end
      
      def when_statuses_are(*codes)
        codes.include?(@response.code)
      end
    end
    
    class EntityError < OpenStruct
      MISSING        = "missing"
      MISSING_FIELD  = "missing_field"
      INVALID        = "invalid"
      ALREADY_EXISTS = "already_exists"
      
      def to_s
        "<Github::Client::EntityError: #{description}>"
      end
      
      def description
        case self.code
          when MISSING
            "#{self.resource} is missing"
          when MISSING_FIELD
            "#{self.resource}##{self.field} is missing"
          when INVALID
            "#{self.resource}##{self.field} is invalid (refer to documentation)"
          when ALREADY_EXISTS
            "#{self.resource}##{self.field} value is already taken (must be unique)"
          else
            "#{self.resource}##{self.field} error: #{self.code}"
        end
      end
    end
  end
end
