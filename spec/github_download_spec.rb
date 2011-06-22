require 'spec_helper'
require 'github/downloads'

describe "Github::Downloads" do
  
  before :each do
    @client = mock("client")
    @downloads = Github::Downloads.new(@client, "username", "somerepo")
  end
  
  describe "#list" do
    it "returns an empty array when there is no downloads" do
      @client.stubs(:get).with("/repos/username/somerepo/downloads").returns successful_response_with([])
      @downloads.list.should be_empty
    end
    
    it "returns an array of downloads parsed from the response when there are downloads" do
      @client.stubs(:get).with("/repos/username/somerepo/downloads").returns successful_response_with([
        {
          "url" => "https://api.github.com/repos/octocat/Hello-World/downloads/1",
          "html_url" => "https://github.com/repos/octocat/Hello-World/downloads/filename",
          "id" => 1,
          "name" => "file.zip",
          "description" => "The latest release",
          "size" => 1024,
          "download_count" => 40
        }
      ])
      @downloads.list.size.should == 1
      @downloads.list.first.description.should == "The latest release"
    end
    
    it "raises if the response is not successful" do
      @client.stubs(:get).with("/repos/username/somerepo/downloads").returns unsuccessful_response
      proc { @downloads.list }.should raise_error(Github::Downloads::UnexpectedResponse)
    end
  end
  
  private
  
  def unsuccessful_response
    stub("response", :success? => false)
  end
  
  def successful_response_with(data)
    stub("response", :success? => true, :data => data)
  end
  
end
