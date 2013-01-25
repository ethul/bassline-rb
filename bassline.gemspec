# -*- encoding: utf-8 -*-
require File.expand_path("../lib/bassline/version", __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["eric thul"]
  gem.email         = ["thul.eric@gmail.com"]
  gem.description   = %q{Bassline description}
  gem.summary       = %q{Bassline summary}
  gem.homepage      = ""

  gem.add_development_dependency("rspec")
  gem.add_development_dependency("fuubar")

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "bassline"
  gem.require_paths = ["lib"]
  gem.version       = Bassline::VERSION
end
