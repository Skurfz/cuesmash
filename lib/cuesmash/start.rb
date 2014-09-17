#!/usr/bin/env ruby
# coding: utf-8

module Cuesmash

  class Start < Thor

    desc 'init', 'set up the project'
    def init
      # Do stuff to set up the directory
    end

    desc 'run OPTIONS', 'Usage: cuesmash [OPTIONS]
                        --tags -t the tags to pass to cucumber, for multiple tags pass one per tag
                        --scheme -s the Xcode scheme to build
                        --ios -i the iOS version to build with
                        --output -o The output directory for the test report
                        --format -f The format of the test report
                        --server -s'
    def run(*options)
      Command.execute(*options)
    end
  end
end
