require 'rake'
require 'rdoc/task'
require "bundler/setup"
require 'rspec/core/rake_task'

desc "Run all examples"
RSpec::Core::RakeTask.new(:specs)

task :default => :specs

require "rubygems"
require "rubygems/package_task"

# This builds the actual gem. For details of what all these options
# mean, and other ones you can add, check the documentation here:
#
#   http://rubygems.org/read/chapter/20
#
spec = Gem::Specification.new do |s|

  # Change these as appropriate
  s.name              = "github-downloads"
  s.version           = "0.1.0"
  s.summary           = "Manages downloads for your Github projects"
  s.author            = "Luke Redpath"
  s.email             = "luke@lukeredpath.co.uk"
  s.homepage          = "http://lukeredpath.co.uk"

  s.has_rdoc          = true
  s.extra_rdoc_files  = %w(README)
  s.rdoc_options      = %w(--main README)

  # Add any extra files to include in the gem
  s.files             = %w(Gemfile Gemfile.lock Rakefile README) + Dir.glob("{bin,spec,lib}/**/*")
  s.executables       = FileList["bin/**"].map { |f| File.basename(f) }
  s.require_paths     = ["lib"]

  # If you want to depend on other gems, add them here, along with any
  # relevant versions
  gem "rest-client"
  gem "json"
  gem "simpleconsole"
  gem "hirb"
  gem "mime-types"
  gem "highline"
  
  s.add_dependency("rest-client", "~> 1.6.3")
  s.add_dependency("json", "~> 1.5.3")
  s.add_dependency("simpleconsole", "~> 0.1.1")
  s.add_dependency("hirb", "~> 0.4.5")
  s.add_dependency("mime-types", "~> 1.16.0")
  s.add_dependency("highline", "~> 1.6.2")

  # If your tests use any gems, include them here
  s.add_development_dependency("rspec")
  s.add_development_dependency("mocha")
  s.add_development_dependency("mimic")
  s.add_development_dependency("awesome_print")
end

# This task actually builds the gem. We also regenerate a static
# .gemspec file, which is useful if something (i.e. GitHub) will
# be automatically building a gem for this project. If you're not
# using GitHub, edit as appropriate.
#
# To publish your gem online, install the 'gemcutter' gem; Read more 
# about that here: http://gemcutter.org/pages/gem_docs
Gem::PackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "Build the gemspec file #{spec.name}.gemspec"
task :gemspec do
  file = File.dirname(__FILE__) + "/#{spec.name}.gemspec"
  File.open(file, "w") {|f| f << spec.to_ruby }
end

# If you don't want to generate the .gemspec file, just remove this line. Reasons
# why you might want to generate a gemspec:
#  - using bundler with a git source
#  - building the gem without rake (i.e. gem build blah.gemspec)
#  - maybe others?
task :package => :gemspec

# Generate documentation
RDoc::Task.new do |rd|
  rd.main = "README"
  rd.rdoc_files.include("README", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
