# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nanosearch/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Marcin Ciunelis"]
  gem.email         = ["marcin.ciunelis@gmail.com"]
  gem.description   = %q{Simple self-hosted RESTfull search engine}
  gem.homepage      = "https://github.com/martinciu/nanosearch"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "nanosearch"
  gem.require_paths = ["lib"]
  gem.version       = Nanosearch::VERSION
end
