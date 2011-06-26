require 'ostruct'
require 'mimetype_fu'

module Github
  class Downloads
    attr_accessor :uploader
    
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
        :content_type => File.mime_type?(file_path)
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
