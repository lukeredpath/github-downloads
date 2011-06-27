# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{github-downloads}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{Luke Redpath}]
  s.date = %q{2011-06-27}
  s.email = %q{luke@lukeredpath.co.uk}
  s.executables = [%q{github-downloads}]
  s.files = [%q{Gemfile}, %q{Gemfile.lock}, %q{Rakefile}, %q{README.md}, %q{bin/github-downloads}, %q{spec/fixtures/textfile.txt}, %q{spec/github_client_spec.rb}, %q{spec/github_download_spec.rb}, %q{spec/spec_helper.rb}, %q{lib/github/client.rb}, %q{lib/github/downloads.rb}, %q{lib/github/downloads_controller.rb}, %q{lib/github/s3_uploader.rb}, %q{lib/github.rb}]
  s.homepage = %q{http://lukeredpath.co.uk}
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.5}
  s.summary = %q{Manages downloads for your Github projects}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>, ["~> 1.6.3"])
      s.add_runtime_dependency(%q<json>, ["~> 1.5.3"])
      s.add_runtime_dependency(%q<simpleconsole>, ["~> 0.1.1"])
      s.add_runtime_dependency(%q<hirb>, ["~> 0.4.5"])
      s.add_runtime_dependency(%q<mime-types>, ["~> 1.16.0"])
      s.add_runtime_dependency(%q<highline>, ["~> 1.6.2"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<mimic>, [">= 0"])
      s.add_development_dependency(%q<awesome_print>, [">= 0"])
    else
      s.add_dependency(%q<rest-client>, ["~> 1.6.3"])
      s.add_dependency(%q<json>, ["~> 1.5.3"])
      s.add_dependency(%q<simpleconsole>, ["~> 0.1.1"])
      s.add_dependency(%q<hirb>, ["~> 0.4.5"])
      s.add_dependency(%q<mime-types>, ["~> 1.16.0"])
      s.add_dependency(%q<highline>, ["~> 1.6.2"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<mimic>, [">= 0"])
      s.add_dependency(%q<awesome_print>, [">= 0"])
    end
  else
    s.add_dependency(%q<rest-client>, ["~> 1.6.3"])
    s.add_dependency(%q<json>, ["~> 1.5.3"])
    s.add_dependency(%q<simpleconsole>, ["~> 0.1.1"])
    s.add_dependency(%q<hirb>, ["~> 0.4.5"])
    s.add_dependency(%q<mime-types>, ["~> 1.16.0"])
    s.add_dependency(%q<highline>, ["~> 1.6.2"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<mimic>, [">= 0"])
    s.add_dependency(%q<awesome_print>, [">= 0"])
  end
end
