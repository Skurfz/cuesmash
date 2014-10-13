# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "cuesmash"
  spec.version       = "0.1.3"
  spec.authors       = ["Alex Fish", "Jarod McBride"]
  spec.email         = ["fish@ustwo.co.uk", "jarod@ustwo.com"]
  spec.description   = "A gift for Juan"
  spec.summary       = "Compile an app, point the app at sinatra, run cucumber with appium"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "byebug"

  spec.add_runtime_dependency "CFPropertyList", '~> 2.2.8'
  spec.add_runtime_dependency "thor", '~> 0.19.1'
  spec.add_runtime_dependency "xcpretty", '~> 0.1.7'

  spec.executables << "cuesmash"
end
