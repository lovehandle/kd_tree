# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kd_tree/version'

Gem::Specification.new do |spec|
  spec.name          = "rb_kd_tree"
  spec.version       = KdTree::VERSION
  spec.authors       = ["Ryan Closner"]
  spec.email         = ["ryan@ryanclosner.com"]
  spec.description   = %q{A KDTree Library}
  spec.summary       = %q{A KDTree Library}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/|^kd_tree$}) { |f| File.basename(f) }
  spec.extensions    = ['ext/kd_tree/extconf.rb']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib", "ext"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rake-compiler"
  spec.add_development_dependency "rspec"
end
