require 'spec_helper'
require 'github'

class FakeResource # fake RestClient::Resource
  attr_reader :path
  
  def initialize(path = "/")
    @path = Mocha::Mockery.instance.new_state_machine("location").starts_as(path)
  end
  
  def [](path)
    tap { @path.become(path) }
  end
end

describe "Github::Client" do
  
  before :each do
    @resource = FakeResource.new
    @client = Github::Client.new(@resource)
  end
  
  describe "#get" do
    it "performs a GET request to /some/path on the resource" do
      @resource.expects(:get).when @resource.path.is("/some/path")
      @client.get("/some/path")
    end
    
    it "returns a Github::Client::Response" do
      @resource.stubs(:get)
      @client.get("/some/path").should be_instance_of(Github::Client::Response)
    end
  end
  
  describe "#post" do
    it "performs a POST request with the supplied data in JSON format to /some/path on the resource" do
      @resource.expects(:post).with({"foo" => "bar"}.to_json).when @resource.path.is("/some/path")
      @client.post("/some/path", {"foo" => "bar"})
    end
    
    it "returns a Github::Client::Response" do
      @resource.stubs(:post)
      @client.post("/some/path", nil).should be_instance_of(Github::Client::Response)
    end
  end
  
end

describe "Github::Client::Response" do
    
  before :each do
    @client = Github::Client.connect("http://localhost:#{Mimic::MIMIC_DEFAULT_PORT}")
  end
  
  after :each do |variable|
    Mimic.cleanup!
  end
  
  def response
    @client.get("/some/path")
  end
  
  def post_response(data = nil)
    @client.post("/some/path", data)
  end
  
  context "for a standard non-paginated 200 response" do
    before :each do
      Mimic.mimic.get("/some/path").returning({"result" => "ok"}.to_json, 200, {"X-RateLimit-Limit" => "5000", "X-RateLimit-Remaining" => "4966"})
    end
    
    it "indicates success" do
      response.should be_success
    end
    
    it "stores the current rate limit" do
      response.rate_limit.should == 5000
    end
    
    it "stores the number of rate-limited requests remaining" do
      response.rate_limit_remaining.should == 4966
    end
    
    it "returns the parsed JSON response" do
      response.data.should == {"result" => "ok"}
    end
  end
  
  context "for 201 created responses" do
    before :each do
      Mimic.mimic.post("/some/path").returning("", 201, {"Location" => "http://example.com/resource"})
    end
    
    it "indicates success" do
      post_response.should be_success
    end
    
    it "returns the location of the created resource" do
      post_response.location.should == "http://example.com/resource"
    end
  end
  
  context "for a bad request" do
    before :each do
      Mimic.mimic.get("/some/path").returning({"message" => "There was an error"}.to_json, 400, {})
    end
    
    it "indicates an error" do
      response.should be_error
      response.should_not be_success
    end
    
    it "returns the error message" do
      response.error_message.should == "There was an error"
    end
  end
  
  context "for requests with invalid data" do
    before :each do
      Mimic.mimic.get("/some/path").returning(
        {"message" => "Validation failed", 
          "errors" => [
            {"resource" => "Issue", "field" => "title", "code" => "missing_field"}
          ]}.to_json, 422, {})
    end
    
    it "indicates an error" do
      response.should be_error
      response.should_not be_success
    end
    
    it "returns the error message" do
      response.error_message.should == "Validation failed"
    end
    
    it "returns the errors" do
      response.should have(1).errors
      response.errors[0].resource.should == "Issue"
      response.errors[0].field.should == "title"
      response.errors[0].code.should == Github::Client::EntityError::MISSING_FIELD
    end
  end
  
end

describe "Github::Client authentication" do
  
  before :each do
    @client = Github::Client.connect("http://localhost:#{mimic_port}")
  end
  
  context "with basic auth" do
    before :each do
      Mimic.mimic do
        use Rack::Auth::Basic do |user, pass|
          user == "joebloggs" and pass == "letmein"
        end
  
        get("/some/path") { [200, {}, ""] }
      end
    end
    
    it "should succeed when authenticated correctly" do
      @client.authenticate_using_basic("joebloggs", "letmein")
      @client.get("/some/path").should be_success
    end
    
    it "should fail when not authenticated correctly" do
      @client.authenticate_using_basic("joebloggs", "wrongpass")
      @client.get("/some/path").should be_error
    end
  end
  
end
