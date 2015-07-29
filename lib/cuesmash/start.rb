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
require 'json'

module Cuesmash
  CONFIG_FILE = '.cuesmash.yml'

  # For information on how this class works see the thor documentation https://github.com/erikhuda/thor/wiki
  class Start < Thor
    package_name 'cuesmash'
    class_option :version, aliases: '-v', desc: 'The version of cuesmash running'

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
      --scheme -s iOS only: the Xcode scheme to build\n
      --app_name -n Android only: the name of the app\n
      --debug -d BOOLEAN turn on debug output\n
      --travis_ci -c BOOLEAN turn on settings for building on Travis CI\n
      --server -r BOOLEAN start up server (requires sinatra app in the project directory)\n
      --profile -p which cucumber.yml profile to use\n
      --quiet -q BOOLEAN cucumber quiet mode
    LONGDESC
    method_option :scheme, type: :array, aliases: '-s', desc: 'iOS only: the Xcode scheme to build'
    method_option :app_name, type: :string, aliases: '-n', desc: 'Android only: the name of the app'
    method_option :tags,
                  type: :array,
                  aliases: '-t',
                  desc: 'the tags to pass to cucumber, for multiple tags pass one per tag'
    method_option :debug, type: :boolean, default: false, aliases: '-d', desc: 'turn on debug output'
    method_option :travis_ci,
                  type: :boolean,
                  default: false,
                  aliases: '-c', desc: 'turn on settings for building on Travis CI'
    method_option :profile, type: :string, aliases: '-p', desc: 'which cucumber.yml profile to use'
    method_option :quiet, type: :boolean, aliases: '-q', desc: 'cucumber quiet mode'
    def test
      # get the cuesmash.yml config
      @config = load_config

      unless @config['mock_server_conf'].nil?
        mock_server = JsonConf.new(app_path: @config['mock_server_conf']['path'],
                                   file_name: @config['mock_server_conf']['name'],
                                   port: @config['mock_server_conf']['port'])

        mock_server.execute
      end

      # Compile the project
      if @config['platform'] == 'iOS'
        # enumerate over each device / OS combination and run the tests.
        @config['devices'].each do |device, oses|
          oses.each do |os_number, ios_uuid|
            setup_ios(device: ios_uuid)
            case
            when ios_uuid.nil?
              say "\n============================\ntesting iOS #{os_number} on #{device}", :green
              Cuesmash::Command.execute(device: device,
                                        os: os_number,
                                        scheme: options[:scheme],
                                        tags: options[:tags],
                                        debug: options[:debug],
                                        app: @app,
                                        profile: options[:profile],
                                        quiet: options[:quiet],
                                        timeout: @config['default']['test_timeout'].to_s)
            else
              say "\n============================\ntesting iOS #{os_number} on #{device}", :green
              Cuesmash::Command.execute(device: device,
                                        os: os_number,
                                        scheme: options[:scheme],
                                        tags: options[:tags],
                                        debug: options[:debug],
                                        app: @app,
                                        profile: options[:profile],
                                        quiet: options[:quiet],
                                        timeout: @config['default']['test_timeout'].to_s,
                                        ios_uuid: ios_uuid)
            end # case
          end # os each
        end # device each

        # clean up the temp dir
        Logger.info "Cleaning up tmp dir\n"
        FileUtils.remove_entry @app.tmp_dir

      elsif @config['platform'] == 'Android'

        say 'Setting up android', :red

        @app = Cuesmash::AndroidApp.new(project_name: options[:app_name],
                                        build_configuration: @config['build_configuration'])
        setup_android

        # enumerate over each device / OS combination and run the tests.
        if @config['devices']['emulators'].first.nil?
          Cuesmash::AndroidCommand.execute(avd: @config['devices']['emulators'].first,
                                           server: options[:server],
                                           tags: options[:tags],
                                           debug: options[:debug],
                                           app: @app,
                                           profile: options[:profile],
                                           quiet: options[:quiet],
                                           timeout: @config['default']['test_timeout'].to_s)
        else
          @config['devices']['emulators'].each do |emulator|
            say "\n============================\ntesting Android on #{emulator}", :green
            Cuesmash::AndroidCommand.execute(avd: emulator,
                                             server: options[:server],
                                             tags: options[:tags],
                                             debug: options[:debug],
                                             app: @app,
                                             profile: options[:profile],
                                             quiet: options[:quiet],
                                             timeout: @config['default']['test_timeout'].to_s)
          end # device each
        end
      else
        say "please set platform: 'iOS' or 'Android' in your .cuesmash.yml file", :red
        return
      end
    end # test

    desc 'build OPTIONS', 'compile the app and create appium.txt to use for arc'
    long_desc <<-LONGDESC
      --scheme -s iOS: the Xcode scheme to build\n
      --app_name -n Android: the app name
    LONGDESC
    method_option :scheme, type: :array, aliases: '-s', desc: 'the Xcode scheme to build'
    method_option :app_name, type: :string, aliases: '-n', desc: 'Android only: the name of the app'
    def build
      # get the cuesmash.yml config
      @config = load_config

      # if no default then bail
      if @config['default'].nil?
        say 'add a default device and os version to the .cuesmash.yml', :red
        return
      end

      unless @config['mock_server_conf'].nil?
        mock_server = JsonConf.new(app_path: @config['mock_server_conf']['path'],
                                   file_name: @config['mock_server_conf']['name'],
                                   port: @config['mock_server_conf']['port'])

        mock_server.execute
      end

      if @config['platform'] == 'iOS'
        setup_ios(device: @config['default']['uuid'])
      elsif @config['platform'] == 'Android'
        say 'Setting up android'
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
        if File.exist?(CONFIG_FILE)
          config = YAML.load_file(CONFIG_FILE) if File.exist?(CONFIG_FILE)
        else
          say "There is no '.cuesmash.yml' file. Please create one and try again.\n", :red
          return
        end
        config
      end # load_config

      #
      # helper method to setup and compile the iOS app
      #
      # @param [string] device: nil <the UUID of the device to run on or nil if running on simulator>
      #
      def setup_ios(device: nil)
        @app = IosApp.new(file_name: options[:scheme].join(' '),
                          build_configuration: @config['build_configuration'],
                          app_name: @config['app_name'],
                          device: device)

        # Compile the project
        compiler = Cuesmash::IosCompiler.new(scheme: options[:scheme].join(' '),
                                             tmp_dir: @app.tmp_dir,
                                             build_configuration: @config['build_configuration'],
                                             device: device)
        compiler.compile

        ios_appium_text
      end # setup_ios

      #
      # helper method for setting up android build
      #
      def setup_android
        @app = Cuesmash::AndroidApp.new(project_name: options[:app_name],
                                        build_configuration: @config['build_configuration'])

        # Compile the project
        compiler = Cuesmash::AndroidCompiler.new(project_name: options[:app_name],
                                                 build_configuration: @config['build_configuration'])
        compiler.compile

        android_appium_text
      end # setup_android

      #
      # iOS Appium text file set up
      #
      def ios_appium_text
        appium = Cuesmash::AppiumText.new(platform_name: 'iOS',
                                          device_name: @config['default']['os'],
                                          platform_version: @config['default']['version'].to_s,
                                          app: @app.app_path,
                                          new_command_timeout: @config['default']['test_timeout'].to_s,
                                          udid: @config['default']['udid'])
        appium.execute
      end # ios_appium_text

      #
      # Android Appium text file set up
      #
      def android_appium_text
        appium = Cuesmash::AndroidAppiumText.new(platform_name: @config['platform'],
                                                 avd: @config['devices']['emulators'].first,
                                                 app: @app.app_path,
                                                 new_command_timeout: @config['default']['test_timeout'].to_s)
        appium.execute
      end # android_appium_text
    end # no_commands
  end # Start class
end # module Cuesmash
