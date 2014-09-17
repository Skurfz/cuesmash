cuesmash
========

<!-- [![Gem Version](https://badge.fury.io/rb/cuesmash.png)](http://badge.fury.io/rb/cuesmash)
[![Build Status](https://travis-ci.org/ustwo/cuesmash.png?branch=master)](https://travis-ci.org/ustwo/cuesmash) -->

Cuesmash provides an interface to run a suite of appium-cucumber tests against an iOS application using a mocked backend. This is a fork of [calasmash](https://github.com/ustwo/cuesmash) that supports appium instead of calabash.

## Installation

From the git repo:

    rake install

Once we get to a first release of them gem there will be a gem install

<!-- Add this line to your application's Gemfile:

    gem 'cuesmash'

And then execute:

    $ bundle install -->

## Usage

###Commands

    cuesmash help [COMMAND]  # Describe available commands or one specific command
    cuesmash init            # set up the project
    cuesmash test OPTIONS    # Usage: cuesmash test [OPTIONS]

### Test Options

    --tags -t the tags to pass to Cucumber, for multiple tags pass one -t option per tag
    --scheme -s the Xcode scheme to build
    --ios -i the iOS version to build with
    --output -o The output directory for the test report
    --format -f The format of the test report
    --debug -d output debug information

## Configuration

Cover what the appium.txt file does.
[http://appium.io/slate/en/tutorial/ios.html?ruby#starting-the-console](http://appium.io/slate/en/tutorial/ios.html?ruby#starting-the-console)

Cover how to configure the travis.yml file
[http://docs.travis-ci.com/user/languages/objective-c/](http://docs.travis-ci.com/user/languages/objective-c/)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## TODO:

1. `cuesmash init` - a command that sets up a new iOS or Andriod repo with cucumber, appium, and needed dependencies.
2. reporting - at the end of a run provide reports of the results.
3. passing build options to xcodebuild (sandbox, mocked, live).
