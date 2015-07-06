# coding: utf-8
gem_name = "mini_object"

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "#{gem_name}"

Gem::Specification.new do |spec|
  spec.name          = gem_name
  spec.version       = MiniObject::VERSION
  spec.authors       = ["Manuel Morales"]
  spec.email         = ['manuelmorales@gmail.com']
  spec.summary       = 'Easier working with instances instead of classes and dependency injection'
  spec.description   = 'A set of tools which will make easier to work with objects instead of classes and injecting dependencies.'
  spec.homepage      = "https://github.com/manuelmorales/#{spec.name.gsub('_','-')}"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "forwarding_dsl", "~> 1.0"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", '~> 10.4'
  spec.add_development_dependency "gem-release", '~> 0.7'
end
