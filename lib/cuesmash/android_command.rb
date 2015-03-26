#!/usr/bin/env ruby
# coding: utf-8
require 'cuesmash/android_appium_text'

module Cuesmash
  #
  # The main point of entry for all commands, Command parses command line arguments
  # and decides what to do about them.
  #
  # @author [alexfish]
  #
  class AndroidCommand
    #
    # Execute a command with some arguments
    # then figure out what we're supposed to be doing with
    # the arguments
    #
    # @param avd: [type] [description]
    # @param server: [type] [description]
    # @param tags: [type] [description]
    # @param debug: false [type] [description]
    # @param format: nil [type] [description]
    # @param output: nil [type] [description]
    # @param app: [type] [description]
    # @param profile: [type] [description]
    # @param quiet: false [type] [description]
    # @param timeout: [type] [description]
    #
    # @return [type] [description]
    def self.execute(avd:, server:, tags:, debug: false, format: nil, output: nil, app:, profile:, quiet: false, timeout:)
      if debug
        Logger.level = ::Logger::DEBUG
        Logger.formatter = proc do |serverity, time, _progname, msg|
          "\n#{time}\t#{serverity}\t#{msg.rstrip}"
        end
      end

      # Update the appium.txt file
      create_appium_txt(app: app.app_path, timeout: timeout, avd: avd)

      # start the appium server
      app_server = AppiumServer.new
      app_server.start_server

      # Run the tests
      run_tests(tags: tags, profile: profile, format: format, output: output, quiet: quiet)
    end # execute

    #
    # Run the cucumber tests, that's why we're here afterall
    #
    # @param tags [Array] The cucumber tags to test with
    # @param profile [String] cucumber profile to use
    # @param format [String] The output format for the cucumber tests, Optional
    # @param output [String] The path to the output directory to output test reports to, Optional
    # @param quiet [Boolean] quiet flag for cucumber
    #
    def self.run_tests(tags:, profile:, format: nil, output: nil, quiet: false)
      cucumber = Cuesmash::Cucumber.new(tags, profile, quiet)
      cucumber.format = format if format
      cucumber.output = output if output
      cucumber.test
    end

    #
    # Update appium.txt file with the directory of the build product
    #
    # @param platform_name [String] default 'iOS' name of platform to test on (Android or iOS)
    # @param device_name [String] deviceName = "iPhone Simulator"
    # @param platform_version [String] platformVersion = "7.1"
    # @param app [String] path to built .app file
    # @param timeout [String] time in seconds to set the newCommandTimeout to.
    #
    def self.create_appium_txt(platform_name: 'Android', app:, timeout:, avd:)
      appium = Cuesmash::AndroidAppiumText.new(platform_name: platform_name,
                                               avd: avd,
                                               app: app,
                                               new_command_timeout: timeout)
      appium.execute
    end
  end # class Command
end # module Cuesmash
