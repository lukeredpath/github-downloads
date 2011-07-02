require 'ostruct'
require 'mime/types'
require 'github/client'
require 'github/s3_uploader'

module Github
  class Downloads
    attr_accessor :uploader
    attr_reader :last_response

    GITHUB_BASE_URL = "https://api.github.com"

    def initialize(client, user, repos)
      @client = client
      @user = user
      @repos = repos
      @last_response = nil
    end

    def self.connect(user, password, repos)
      client = Client.connect(GITHUB_BASE_URL, user, password)
      new(client, user, repos).tap do |downloader|
        downloader.uploader = Github::S3Uploader.new # default uploader
      end
    end

    class UnexpectedResponse < StandardError
      attr_reader :response

      def initialize(response)
        @response = response
      end
    end

    def list
      @last_response = @client.get(downloads_resource_path)

      if @last_response.success?
        from_response_data(@last_response.data)
      else
        raise UnexpectedResponse, @last_response
      end
    end

    def create(file_path, description = "", options={})
      delete(:name => File.basename(file_path)) if options[:overwrite]
      
      @last_response = @client.post(downloads_resource_path, {
        :name         => File.basename(file_path),
        :description  => description,
        :content_type => MIME::Types.type_for(file_path)[0] || MIME::Types["application/octet-stream"][0],
        :size         => File.size?(file_path)
      })

      if @last_response.success?
        uploader.upload(File.expand_path(file_path), @last_response.data)
      end
    end

    def delete(options={})
      if download_id = options[:id]
        delete_download_with_id(download_id)
      elsif file_name = options[:name]
        download = list.find { |download| download.name == file_name }
        delete_download_with_id(download.download_id) if download
      else
        raise "Either :id or :name should be specified"
      end
    end

    private

    def delete_download_with_id(id)
      @last_response = @client.delete("#{downloads_resource_path}/#{id}")
      @last_response.success?
    end

    def downloads_resource_path
      "/repos/#{@user}/#{@repos}/downloads"
    end

    def from_response_data(data)
      data.map do |hash|
        # OpenStruct doesn't like :id attributes
        Download.new(with_swapped_key(hash, "id", "download_id"))
      end
    end
    
    def with_swapped_key(hash, old_key, new_key)
      hash[new_key] = hash[old_key]
      hash
    end

    class Download < OpenStruct
    end
  end
end
