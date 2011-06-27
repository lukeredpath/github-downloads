require 'restclient'

module Github
  class S3Uploader 
    def upload(path, metadata)
      RestClient.post("http://github.s3.amazonaws.com/", [
        ["key", "#{metadata["prefix"]}#{metadata["name"]}"],
        ["acl", metadata["acl"]],
        ["success_action_redirect", metadata["redirect"]],
        ["Filename", metadata["name"]],
        ["AWSAccessKeyId", metadata["accesskeyid"]],
        ["Policy", metadata["policy"]],
        ["Signature", metadata["signature"]],
        ["Content-Type", metadata["mime_type"]],
        ["file", File.open(path)]
      ])
    rescue
    end
  end
end
