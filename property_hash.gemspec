require File.join(File.dirname(__FILE__), "lib/property_hash")

Gem::Specification.new do |spec|
  spec.name          = "property_hash"
  spec.version       = PropertyHash::VERSION
  spec.authors       = ["Skye Shaw"]
  spec.email         = ["skye.shaw@gmail.com"]

  spec.summary       = %q{Access a nested Ruby Hash using Java-style properties as keys.}
  spec.description   = %q{Access a nested Ruby Hash using Java-style properties as keys.}
  spec.homepage      = "https://github.com/sshaw/property_hash"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/sshaw/property_hash"
    # spec.metadata["changelog_uri"] = ""
  end

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
