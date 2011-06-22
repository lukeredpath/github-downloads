require 'ostruct'

module Github
  class Downloads
    def initialize(client, user, repos)
      @client = client
      @user = user
      @repos = repos
    end
    
    class UnexpectedResponse < StandardError
      attr_reader :response
      
      def initialize(response)
        @response = response
      end
    end
    
    def list
      response = @client.get("/repos/#{@user}/#{@repos}/downloads")
      
      if response.success?
        from_response_data(response.data)
      else
        raise UnexpectedResponse, response
      end
    end
    
    private
    
    def from_response_data(data)
      data.map { |hash| Download.new(hash) }
    end
    
    class Download < OpenStruct
    end
  end
end
