#!/usr/bin/env ruby
# coding: utf-8

require 'thor'
require 'cuesmash'
require 'cuesmash/setup'

module Cuesmash

  CONFIG_FILE = '.cuesmash.yml'

  class Start < Thor

    desc 'init', 'set up the project'
    def init
      Cuesmash::Setup.setup
    end

    desc "test OPTIONS", "run the tests"
    long_desc <<-LONGDESC
      --tags -t the tags to pass to cucumber, for multiple tags pass one per tag\n
      --output -o The output directory for the test report\n
      --format -f The format of the test report\n
      --server -s
    LONGDESC
    method_option :scheme, type: :string, aliases: "-s", desc: "the Xcode scheme to build"
    method_option :tags, type: :array, aliases: "-t", desc: "the tags to pass to cucumber, for multiple tags pass one per tag"
    method_option :debug, type: :boolean, default: false, aliases: "-d", desc: "turn on debug output."
    method_option :travis_ci, type: :boolean, default: false, aliases: "-c", desc: "turn on settings for building on Travis CI"
    # method_option :server, type: :string, aliases: "-r", desc: ""
    def test

      # load up the .cuesmash.yml config. If we don't find one then bail
      if File.exists?(CONFIG_FILE)
        config = YAML.load_file(CONFIG_FILE) if File.exists?(CONFIG_FILE)
      else
        say "There is no '.cuesmash.yml' file. Please create one and try again.", :red
        return
      end

      config['devices'].each do |device, oses|
        oses.each do |os|
          say "\n============================\ntesting iOS #{os} on #{device}", :green
          Cuesmash::Command.execute(device: device, os: os, server: options[:server], tags: options[:tags], scheme: options[:scheme], travis: options[:travis_ci], debug: options[:debug])
        end
      end # device each
    end # test
  end # Start class
end # module Cuesmash
