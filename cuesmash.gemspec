# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "cuesmash"
  spec.version       = "0.1.10"
  spec.authors       = ["Alex Fish", "Jarod McBride", "Tiago Castro"]
  spec.email         = ["fish@ustwo.co.uk", "jarod@ustwo.com", "castro@ustwo.com"]
  spec.description   = "Appium project manager"
  spec.summary       = "Compile an app and run cucumber with appium"
  spec.homepage      = "https://github.com/ustwo/cuesmash"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.1.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'rake', '>= 10.3.2'
  spec.add_development_dependency 'rspec', '>= 3.1.0'
  spec.add_development_dependency 'guard-rspec', '>= 4.3.1'
  spec.add_development_dependency 'pry', '>= 0.10.1'
  spec.add_development_dependency 'byebug', '>= 3.5.1'
  spec.add_development_dependency 'simplecov', '~> 0.9.0'

  spec.add_runtime_dependency 'CFPropertyList', '>= 2.2.8'
  spec.add_runtime_dependency 'thor', '>= 0.19.1'
  spec.add_runtime_dependency 'xcpretty', '>= 0.1.7'
  spec.add_runtime_dependency 'rest-client', '~> 1.7.2'

  spec.executables << "cuesmash"
end
