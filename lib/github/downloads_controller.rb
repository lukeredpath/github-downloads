require 'simpleconsole'
require 'hirb'
require 'highline/import'
require 'osx_keychain'

require 'github/downloads'
require 'github/s3_uploader'

module Github
  class DownloadsController < SimpleConsole::Controller
    include Hirb::Console
    
    params :string => { 
      :u => :user, 
      :f => :file, 
      :n => :name, 
      :r => :repos,
      :d => :description,
      :p => :proxy
    }, 
    :bool => {
      :o => :overwrite
    }
        
    before_filter :set_proxy
    
    def default
      puts "Valid actions: list, upload, delete"
      exit 1
    end
    
    def list
      if (downloads = github.list)
        table downloads, {:fields => [:name, :description, :download_count]}
      else
        puts "Couldn't fetch downloads!"
      end
    rescue Github::Downloads::UnexpectedResponse => e
      fail! "Unexpected response (#{e.response})."
    end
    
    def create
      if params[:file].nil?
        fail! "* A file must be specified (-f or --file)"
      end

      if (url_for_upload = github(:authenticated).create(params[:file], params[:description]))
        puts "Upload successful! (#{url_for_upload})"
      else
        fail! "Upload failed!"
      end
    rescue Github::Downloads::UnexpectedResponse => e
      fail! "Unexpected response (#{e.response})."
    end
    
    private
    
    def fail!(message, status = 1)
      puts(message)
      exit(status)
    end
    
    def fetch_downloads(repo)
       Hpricot(open("https://github.com/#{repo}/downloads"))
    end
    
    def set_proxy
      Github::Client.proxy = params[:proxy]
    end
    
    def github(authentication_required = false)
      if params[:repos].nil? || params[:user].nil?
        fail! "* Please specify a user (-u or --user) and repository (-r or --repos)"
      end
      
      if authentication_required
        password = lookup_or_prompt_for_password(params[:user])
      end
      
      @github ||= Github::Downloads.connect(params[:user], password, params[:repos]).tap do |gh|
        gh.uploader = Github::S3Uploader.new
      end
    end
    
    def lookup_or_prompt_for_password(user)
      fetch_password_from_keychain(user) || prompt_for_password(user)
    end
    
    def prompt_for_password(user)
      ask("Enter Github password:") {|q| q.echo = false }.tap do |password|
        store_password_in_keychain(user, password)
      end
    end
    
    def mac?
      RUBY_PLATFORM.match(/darwin/)
    end
    
    KEYCHAIN_SERVICE = "github-uploads"
    
    def fetch_password_from_keychain(user)
      OSXKeychain.new[KEYCHAIN_SERVICE, user] if mac?
    end
    
    def store_password_in_keychain(user, password)
      OSXKeychain.new[KEYCHAIN_SERVICE, user] = password if mac?
    end
  end
end
