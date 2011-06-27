require 'ostruct'
require 'mime/types'
require 'github/client'

RestClient.log = STDOUT

module Github
  class Downloads
    attr_accessor :uploader
    
    GITHUB_BASE_URL = "https://api.github.com"
    
    def initialize(client, user, repos)
      @client = client
      @user = user
      @repos = repos
    end
    
    def self.connect(user, password, repos)
      client = Client.connect(GITHUB_BASE_URL, user, password)
      new(client, user, repos)
    end
    
    class UnexpectedResponse < StandardError
      attr_reader :response
      
      def initialize(response)
        @response = response
      end
    end
    
    def list
      response = @client.get(downloads_resource_path)
      
      if response.success?
        from_response_data(response.data)
      else
        raise UnexpectedResponse, response
      end
    end
    
    def upload(file_path, description = "")
      response = @client.post(downloads_resource_path, {
        :name         => File.basename(file_path),
        :description  => description,
        :content_type => MIME::Types.type_for(file_path)[0] || MIME::Types["application/octet-stream"][0]
      })
      
      if response.success?
        uploader.upload(File.expand_path(file_path), response.data)
      end
    end
    
    private
    
    def downloads_resource_path
      "/repos/#{@user}/#{@repos}/downloads"
    end
    
    def from_response_data(data)
      data.map { |hash| Download.new(hash) }
    end
    
    class Download < OpenStruct
    end
  end
end
