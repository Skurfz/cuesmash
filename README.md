cuesmash
========

[![Gem Version](https://badge.fury.io/rb/cuesmash.svg)](http://badge.fury.io/rb/cuesmash)
[![Build Status](https://magnum.travis-ci.com/ustwo/cuesmash.svg?token=jygZyQ1odWsnJPYYao3U)](https://magnum.travis-ci.com/ustwo/cuesmash)

Cuesmash provides an interface to run a suite of appium-cucumber tests against an iOS application using a mocked backend. This is a fork of [calasmash](https://github.com/ustwo/cuesmash) that supports appium instead of calabash.

## Installation
<!--
From the git repo:

    rake install

Once we get to a first release of them gem there will be a gem install -->

Add this line to your application's Gemfile:

    gem 'cuesmash'

And then execute:

    $ bundle install

Or as a standalone:

    $ gem install cuesmash



## Usage

###Commands

    cuesmash help [COMMAND]  # Describe available commands or one specific command
    cuesmash init            # set up the project
    cuesmash test OPTIONS    # Usage: cuesmash test [OPTIONS]

###init

The init command `cuesmash init` should be run from the root of a new iOS or Android project.

### Test Options

    --tags -t the tags to pass to cucumber, for multiple tags pass one per tag. See cucumber tags for more info. https://github.com/cucumber/cucumber/wiki/Tags\n
    --output -o The output directory for the test report --not yet implemented--\n
    --format -f The format of the test report --not yet implemented--\n
    --scheme -s the Xcode scheme to build\n
    --debug -d BOOLEAN turn on debug output\n
    --travis_ci -c BOOLEAN turn on settings for building on Travis CI
    --server -r BOOLEAN start up server (requires sinatra app in the project directory)

## Configuration

Cover what the appium.txt file does.
[http://appium.io/slate/en/tutorial/ios.html?ruby#starting-the-console](http://appium.io/slate/en/tutorial/ios.html?ruby#starting-the-console)

Cover how to configure the travis.yml file
[http://docs.travis-ci.com/user/languages/objective-c/](http://docs.travis-ci.com/user/languages/objective-c/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. write some code and tests
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create new Pull Request

## Running tests

    $ rspec

## Building and pushing

    - make sure all tests are passing
    - update `cuesmash.gemspec` version number
    - `gem build cuesmash.gemspec `
    - `gem uninstall -x cuesmash && rake install `
    - manually test
    - push to rubygems.org `gem push cuesmash-0.1.7.gem `


## TODO:

1. reporting - at the end of a run provide reports of the results.
2. passing build options to xcodebuild (sandbox, mocked, live).
