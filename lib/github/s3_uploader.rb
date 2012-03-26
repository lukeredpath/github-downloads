require 'restclient'

module Github
  class S3Uploader 
    def upload(path, metadata)
      response = RestClient.post(metadata["s3_url"], [
        ["key", "#{metadata["path"]}"],
        ["acl", metadata["acl"]],
        ["success_action_status", 201],
        ["Filename", metadata["name"]],
        ["AWSAccessKeyId", metadata["accesskeyid"]],
        ["Policy", metadata["policy"]],
        ["Signature", metadata["signature"]],
        ["Content-Type", metadata["mime_type"]],
        ["file", File.open(path)]
      ])
      if response.code == 201
        metadata["url"]
      else 
        false
      end
    end
  end
end
