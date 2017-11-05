
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ticket_alert/version"

Gem::Specification.new do |spec|
  spec.name          = "ticket_alert"
  spec.version       = TicketAlert::VERSION
  spec.authors       = ["Antonio"]
  spec.email         = ["carrasco.acd@gmail.com"]

  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rspec", "~> 3.7.0"
  spec.add_dependency "watir", "~> 6.8.4"
  spec.add_dependency "mail", "~> 2.7.0"
  spec.add_dependency "dotenv", "~> 2.2.1"
  spec.add_dependency "redis", "~>  4.0.1"
  spec.add_dependency "rake", "~> 10.5.0"
  spec.add_dependency "headless", '~> 2.3.1'
end
