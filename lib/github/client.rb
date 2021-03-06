require 'restclient'
require 'ostruct'
require 'json'

module Github
  class Client
    class << self
      def connect(base_url, user = nil, pass = nil)
        new RestClient::Resource.new(base_url, user, pass)
      end
      
      def proxy=(proxy_host)
        RestClient.proxy = proxy_host
      end
    end
    
    def initialize(resource)
      @resource = resource
    end
    
    def get(path)
      request :get, path
    end
    
    def post(path, data)
      request :post, path, data
    end
    
    def put(path, data)
      request :put, path, data
    end
    
    def delete(path)
      request :delete, path
    end
    
    def head(path)
      request :head, path
    end
    
    private
    
    def request(method, path, data = nil)
      if data
        Response.new(@resource[path].send(method, data.to_json))
      else
        Response.new(@resource[path].send(method))
      end
    rescue RestClient::Exception => e
      if Response.can_handle?(e.response)
        Response.new(e.response)
      else
        raise e
      end
    end
    
    class Response
      SUCCESS_CODES = [200, 201]
      FAILURE_CODES = [400, 401, 422]
      
      def initialize(response)
        @response = response
      end
      
      def self.can_handle?(response)
        (SUCCESS_CODES + FAILURE_CODES).include?(response.code)
      end
      
      def to_s
        "#{@response.description.strip} | Rate limit: #{rate_limit_remaining} / #{rate_limit_remaining}"
      end
      
      def success?
        when_statuses_are *SUCCESS_CODES
      end
      
      def error?
        when_statuses_are *FAILURE_CODES
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
