#!/usr/bin/env ruby
# coding: utf-8

require 'thor'
require 'cuesmash'
require 'cuesmash/ios_compiler'
require 'cuesmash/android_app'
require 'cuesmash/android_compiler'
require 'cuesmash/android_command'
require 'cuesmash/setup'
require 'byebug'

module Cuesmash

  CONFIG_FILE = '.cuesmash.yml'

  # For information on how this class works see the thor documentation https://github.com/erikhuda/thor/wiki
  class Start < Thor

    desc 'init', 'set up the project'
    def init
      Cuesmash::Setup.setup
    end

    desc "test OPTIONS", "run the tests"
    long_desc <<-LONGDESC
      --tags -t the tags to pass to cucumber, for multiple tags pass one per tag. See cucumber tags for more info. https://github.com/cucumber/cucumber/wiki/Tags\n
      --output -o The output directory for the test report --not yet implemented--\n
      --format -f The format of the test report --not yet implemented--\n
      --scheme -s iOS only: the Xcode scheme to build\n
      --app_name -n Android only: the name of the app\n
      --debug -d BOOLEAN turn on debug output\n
      --travis_ci -c BOOLEAN turn on settings for building on Travis CI\n
      --server -r BOOLEAN start up server (requires sinatra app in the project directory)\n
      --profile -p which cucumber.yml profile to use\n
      --quiet -q BOOLEAN cucumber quiet mode
    LONGDESC
    method_option :scheme, type: :string, aliases: "-s", desc: "iOS only: the Xcode scheme to build"
    method_option :app_name, type: :string, aliases: "-n", desc: "Android only: the name of the app"
    method_option :tags, type: :array, aliases: "-t", desc: "the tags to pass to cucumber, for multiple tags pass one per tag"
    method_option :debug, type: :boolean, default: false, aliases: "-d", desc: "turn on debug output"
    method_option :travis_ci, type: :boolean, default: false, aliases: "-c", desc: "turn on settings for building on Travis CI"
    method_option :profile, type: :string, aliases: "-p", desc: "which cucumber.yml profile to use"
    method_option :quiet, type: :boolean, aliases: "-q", desc: "cucumber quiet mode"
    # method_option :server, type: :string, aliases: "-r", desc: ""
    def test

      # get the cuesmash.yml config
      @config = load_config

      # Compile the project
      if @config['platform'] == 'iOS'

        # Create new IosApp object
        @app = IosApp.new(file_name: options[:scheme], build_configuration: @config['build_configuration'])

        setup_ios

        # enumerate over each device / OS combination and run the tests.
        @config['devices'].each do |device, oses|
          oses.each do |os|
            say "\n============================\ntesting iOS #{os} on #{device}", :green
            Cuesmash::Command.execute(device: device, 
                                      os: os, 
                                      server: options[:server], 
                                      tags: options[:tags], 
                                      scheme: options[:scheme],
                                      debug: options[:debug], 
                                      app: @app, 
                                      profile: options[:profile], 
                                      quiet: options[:quiet],
                                      timeout: @config['default']['test_timeout'].to_s)
          end
        end # device each

        # clean up the temp dir
        Logger.info "Cleaning up tmp dir\n"
        FileUtils.remove_entry @app.tmp_dir
      
      elsif @config['platform'] == 'Android'
      
        say "Setting up android", :red

        @app = Cuesmash::AndroidApp.new(project_name: options[:app_name], build_configuration: @config['build_configuration'])
        setup_android

        # enumerate over each device / OS combination and run the tests.
        @config['devices']['emulators'].each do |emulator|
          say "\n============================\ntesting Android on #{emulator}", :green
          Cuesmash::AndroidCommand.execute( avd: emulator,
                                            server: options[:server], 
                                            tags: options[:tags],
                                            debug: options[:debug],
                                            app: @app, 
                                            profile: options[:profile], 
                                            quiet: options[:quiet], 
                                            timeout: @config['default']['test_timeout'].to_s)
        end # device each
      else
        say "please set platform: 'iOS' or 'Android' in your .cuesmash.yml file", :red
        return
      end
    end # test

    desc "build OPTIONS", "compile the app and create appium.txt to use for arc"
    long_desc <<-LONGDESC
      --scheme -s iOS: the Xcode scheme to build\n
      --app_name -n Android: the app name
    LONGDESC
    method_option :scheme, type: :string, aliases: "-s", desc: "the Xcode scheme to build"
    method_option :app_name, type: :string, aliases: "-n", desc: "Android only: the name of the app"
    def build

      # get the cuesmash.yml config
      @config = load_config

      # if no default then bail
      if @config['default'] == nil
        say "add a default device and os version to the .cuesmash.yml", :red
        return
      end

      if @config['platform'] == 'iOS'
        setup_ios
      elsif @config['platform'] == 'Android'
        say "Setting up android"
        setup_android
      else
        say "please set platform: 'iOS' or 'Android' in your .cuesmash.yml file", :red
        return
      end

      say "\nYour build is available at #{@app.app_path}", :green
    end # build

    no_commands do
      #
      # load up the .cuesmash.yml config. If we don't find one then bail
      #
      # @return [YAML] yaml loaded from the config_file
      def load_config

        if File.exists?(CONFIG_FILE)
          config = YAML.load_file(CONFIG_FILE) if File.exists?(CONFIG_FILE)
        else
          say "There is no '.cuesmash.yml' file. Please create one and try again.\n", :red
          return
        end
        config
      end # end load_config

      #
      # helper methods
      # 
      def setup_ios
        @app = IosApp.new(file_name: options[:scheme], build_configuration: @config['build_configuration'])

        # Compile the project
        compiler = Cuesmash::IosCompiler.new(scheme: options[:scheme], tmp_dir: @app.tmp_dir, build_configuration: @config['build_configuration'])
        compiler.compile

        ios_appium_text
      end

      # 
      # helper method for setting up android build
      # 
      def setup_android
        @app = Cuesmash::AndroidApp.new(project_name: options[:app_name], build_configuration: @config['build_configuration'])

        # Compile the project
        compiler = Cuesmash::AndroidCompiler.new(project_name: options[:app_name],  build_configuration: @config['build_configuration'])
        compiler.compile

        android_appium_text
      end

      #
      # iOS Appium text file set up
      # 
      def ios_appium_text
        appium = Cuesmash::AppiumText.new(platform_name: "iOS", 
                                          device_name: @config['default']['os'], 
                                          platform_version: @config['default']['version'].to_s, 
                                          app: @app.app_path, 
                                          new_command_timeout: @config['default']['test_timeout'].to_s)
        appium.execute
      end

      #
      # Android Appium text file set up
      # 
      def android_appium_text
        appium = Cuesmash::AndroidAppiumText.new( platform_name: @config['platform'],
                                                  avd: @config['default_emulator'],
                                                  app: @app.app_path, 
                                                  new_command_timeout: @config['default']['test_timeout'].to_s)
        appium.execute
      end
    end # no_commands
  end # Start class
end # module Cuesmash
