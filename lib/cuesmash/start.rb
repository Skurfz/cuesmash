#!/usr/bin/env ruby
# coding: utf-8

require 'thor'
require 'cuesmash'
require 'cuesmash/setup'

module Cuesmash

  class Start < Thor

    desc 'init', 'set up the project'
    def init
      Cuesmash::Setup.setup
    end

    desc 'test OPTIONS', "Usage: cuesmash test [OPTIONS]"
    long_desc <<-LONGDESC
      --tags -t the tags to pass to cucumber, for multiple tags pass one per tag\n
      --scheme -s the Xcode scheme to build\n
      --ios -i the iOS version to build with\n
      --output -o The output directory for the test report\n
      --format -f The format of the test report\n
      --server -s
    LONGDESC
    def test(*options)
      Cuesmash::Command.execute(*options)
    end
  end
end
