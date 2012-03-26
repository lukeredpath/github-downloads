# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "github-downloads"
  s.version = "0.1.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Luke Redpath"]
  s.date = "2012-03-26"
  s.email = "luke@lukeredpath.co.uk"
  s.executables = ["github-downloads"]
  s.files = ["Gemfile", "Gemfile.lock", "Rakefile", "README.md", "bin/github-downloads", "spec/fixtures", "spec/fixtures/textfile.txt", "spec/github_client_spec.rb", "spec/github_download_spec.rb", "spec/spec_helper.rb", "lib/github", "lib/github/client.rb", "lib/github/downloads.rb", "lib/github/downloads_controller.rb", "lib/github/s3_uploader.rb", "lib/github.rb"]
  s.homepage = "http://lukeredpath.co.uk"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.11"
  s.summary = "Manages downloads for your Github projects"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, [">= 0"])
      s.add_runtime_dependency(%q<json>, [">= 0"])
      s.add_runtime_dependency(%q<simpleconsole>, [">= 0"])
      s.add_runtime_dependency(%q<hirb>, [">= 0"])
      s.add_runtime_dependency(%q<mime-types>, [">= 0"])
      s.add_runtime_dependency(%q<highline>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<mimic>, [">= 0"])
      s.add_development_dependency(%q<awesome_print>, [">= 0"])
    else
      s.add_dependency(%q<rest-client>, [">= 0"])
      s.add_dependency(%q<json>, [">= 0"])
      s.add_dependency(%q<simpleconsole>, [">= 0"])
      s.add_dependency(%q<hirb>, [">= 0"])
      s.add_dependency(%q<mime-types>, [">= 0"])
      s.add_dependency(%q<highline>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<mimic>, [">= 0"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>, [">= 0"])
    s.add_dependency(%q<json>, [">= 0"])
    s.add_dependency(%q<simpleconsole>, [">= 0"])
    s.add_dependency(%q<hirb>, [">= 0"])
    s.add_dependency(%q<mime-types>, [">= 0"])
    s.add_dependency(%q<highline>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<mimic>, [">= 0"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
  end
end
