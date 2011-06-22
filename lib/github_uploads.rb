require 'restclient'
require 'simpleconsole'
require 'json'
require 'hirb'

module GithubUploads
  class Manager < SimpleConsole::Controller
    include Hirb::Console
    
    params :string => { 
      :l => :login, 
      :t => :token, 
      :f => :file, 
      :n => :name, 
      :r => :repo,
      :d => :description,
      :p => :proxy
    }, 
    :bool => {
      :o => :overwrite
    }
        
    before_filter :set_authentication_params
    
    def default
      puts "Valid actions: list, upload, delete"
      exit 1
    end
    
    def list
      if params[:repo].nil?
        fail! "* Please specify a repository (-r or --repo)"
      end

      downloads = (fetch_downloads(params[:repo]) / "#manual_downloads li").map do |item|
        Download.parse_html(item)
      end

      table downloads, {:fields => [:filename, :description, :size, :uploaded]}
    end
    
    def upload
      if params[:file].nil?
        fail! "* A file must be specified (-f or --file)"
      end
      
      if params[:repo].nil?
        fail! "* A repository (e.g. username/reponame) must be specified (-r or --repo)"
      end
      
      uploader = Uploader.new(@login, @token)
      uploader.proxy = params[:proxy]
      uploader.overwrite = params[:overwrite]
      
      if uploader.upload(params[:file], params[:repo], params[:description], params[:name])
        puts "Upload successful!"
      else
        fail! "Upload failed!"
      end
    end
    
    private
    
    def fail!(message, status = 1)
      puts(message) && exit(status)
    end
    
    def fetch_downloads(repo)
       Hpricot(open("https://github.com/#{repo}/downloads"))
    end
    
    def set_authentication_params
      @login = params[:login] || `git config --global github.user`.strip 
      @token = params[:token] || `git config --global github.token`.strip

      unless @login && @token
        puts "Github login and token must be set using either git config or by using command line options."
        exit 1
      end
    end
    
    class GithubAPI

    end
  end
end
