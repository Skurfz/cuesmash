require 'cuesmash'
require 'simplecov'

SimpleCov.start do
  add_filter '/spec/'
  add_filter '/pkg/'
end

RSpec.configure do |config|
  # ...
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end
