# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mincss/version'

Gem::Specification.new do |spec|
  spec.name          = "mincss"
  spec.version       = Mincss::VERSION
  spec.authors       = ["Mark Wetzel", "Steph Samson"]
  spec.email         = ["mark@markwetzel.com", "sdvsamson@gmail.com"]
  spec.description   = %q{A css file minimizer}
  spec.summary       = %q{mincss minimizes a provided .css file effectively reducing browser download time}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
