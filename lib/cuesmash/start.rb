#!/usr/bin/env ruby
# coding: utf-8

require 'thor'
require 'cuesmash'
require 'cuesmash/setup'

module Cuesmash
  CONFIG_FILE = '.cuesmash.yml'

  # For information on how this class works see the thor documentation https://github.com/erikhuda/thor/wiki
  class Start < Thor
    desc 'init', 'set up the project'
    def init
      Cuesmash::Setup.setup
    end

    desc 'test OPTIONS', 'run the tests'
    long_desc <<-LONGDESC
      --tags -t the tags to pass to cucumber, for multiple tags pass one per tag.
                See cucumber tags for more info. https://github.com/cucumber/cucumber/wiki/Tags\n
      --output -o The output directory for the test report --not yet implemented--\n
      --format -f The format of the test report --not yet implemented--\n
      --scheme -s the Xcode scheme to build\n
      --debug -d BOOLEAN turn on debug output\n
      --travis_ci -c BOOLEAN turn on settings for building on Travis CI\n
      --server -r BOOLEAN start up server (requires sinatra app in the project directory)\n
      --profile -p which cucumber.yml profile to use\n
      --quiet -q BOOLEAN cucumber quiet mode
    LONGDESC
    method_option :scheme, type: :string, aliases: '-s', desc: 'the Xcode scheme to build'
    method_option :tags, type: :array, aliases: '-t', desc: 'the tags to pass to cucumber, for multiple tags pass one per tag'
    method_option :debug, type: :boolean, default: false, aliases: '-d', desc: 'turn on debug output'
    method_option :travis_ci, type: :boolean, default: false, aliases: '-c', desc: 'turn on settings for building on Travis CI'
    method_option :profile, type: :string, aliases: '-p', desc: 'which cucumber.yml profile to use'
    method_option :quiet, type: :boolean, aliases: '-q', desc: 'cucumber quiet mode'
    # method_option :server, type: :string, aliases: "-r", desc: ""
    def test
      # get the cuesmash.yml config
      config = load_config

      # Create new IosApp object
      app = IosApp.new(file_name: options[:scheme],
                       travis_build: options[:travis_ci],
                       build_configuration: config['build_configuration'])

      # Compile the project
      compiler = Cuesmash::Compiler.new(options[:scheme], app.tmp_dir, config['build_configuration'])
      compiler.compile

      # enumerate over each device / OS combination and run the tests.
      config['devices'].each do |device, oses|
        oses.each do |os|
          say "\n============================\ntesting iOS #{os} on #{device}", :green
          Cuesmash::Command.execute(device: device,
                                    os: os,
                                    server: options[:server],
                                    tags: options[:tags],
                                    scheme: options[:scheme],
                                    travis: options[:travis_ci],
                                    debug: options[:debug],
                                    app: app,
                                    profile: options[:profile],
                                    quiet: options[:quiet],
                                    timeout: config['default']['test_timeout'].to_s)
        end
      end # device each

      # clean up the temp dir
      unless options[:travis_ci]
        # clean up temp dir
        Logger.info "Cleaning up tmp dir\n"
        FileUtils.remove_entry app.tmp_dir
      end
    end # test

    desc 'build OPTIONS', 'compile the app and create appium.txt to use for arc'
    long_desc <<-LONGDESC
      --scheme -s the Xcode scheme to build\n
    LONGDESC
    method_option :scheme, type: :string, aliases: '-s', desc: 'the Xcode scheme to build'
    def build
      # get the cuesmash.yml config
      config = load_config

      # if no default then bail
      if config['default'].nil?
        say 'add a default device and os version to the .cuesmash.yml', :red
        return
      end

      # Create new IosApp object
      app = IosApp.new(file_name: options[:scheme], build_configuration: config['build_configuration'])

      # Compile the project
      compiler = Cuesmash::Compiler.new(options[:scheme], app.tmp_dir, config['build_configuration'])
      compiler.compile

      # create the appium text file
      appium = AppiumText.new(platform_name: 'iOS',
                              device_name: config['default']['os'],
                              platform_version: config['default']['version'].to_s,
                              app: app.app_path,
                              new_command_timeout: config['default']['test_timeout'].to_s)
      appium.execute

      say "\nYour build is available at #{app.app_path}", :green
    end # build

    no_commands do
      #
      # load up the .cuesmash.yml config. If we don't find one then bail
      #
      # @return [YAML] yaml loaded from the config_file
      def load_config
        if File.exist?(CONFIG_FILE)
          config = YAML.load_file(CONFIG_FILE) if File.exist?(CONFIG_FILE)
        else
          say "There is no '.cuesmash.yml' file. Please create one and try again.\n", :red
          return
        end
        config
      end # end load_config
    end # no_commands
  end # Start class
end # module Cuesmash
