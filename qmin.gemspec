# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qmin/version'

Gem::Specification.new do |spec|
  spec.name          = 'qmin'
  spec.version       = Qmin::VERSION
  spec.authors       = ['the-architect']
  spec.email         = ['marcel.scherf@epicteams.com']
  spec.description   = %q{Simple framwork to coordinate background tasks}
  spec.summary       = %q{Simple framwork to coordinate background tasks}
  spec.homepage      = 'https://github.com/qmin/qmin'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'debugger'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'mocha'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'simplecov-html'
  spec.add_development_dependency 'metric_fu'
end
