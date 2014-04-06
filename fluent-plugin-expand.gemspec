# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fluent/plugin/expand/version'

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-expand"
  spec.version       = Fluent::Plugin::Expand::VERSION
  spec.authors       = ["Albert Fernández"]
  spec.email         = ["albertfdp@gmail.com"]
  spec.summary       = %q{fluentd plugin to extract items from an array and re.emit them individually.}
  spec.description   = %q{fluentd plugin to extract items from an array and re.emit them individually.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
