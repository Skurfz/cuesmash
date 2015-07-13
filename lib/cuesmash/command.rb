#!/usr/bin/env ruby
# coding: utf-8

module Cuesmash
  #
  # The main point of entry for all commands, Command parses command line arguments
  # and decides what to do about them.
  #
  # @author [alexfish]
  #
  class Command
    #
    # Execute a command with some arguments
    # then figure out what we're supposed to be doing with
    # the arguments
    #
    # @param device [String]
    # @param os [String]
    # @param tags [Array]
    # @param debug [Boolean]
    # @param format [String]
    # @param output [String]
    # @param app [IosApp Object]
    # @param profile [String]
    # @param quiet [String]
    # @param timeout [String] newCommandTimeout for appium in seconds
    #
    # @return [type] [description]
    def self.execute(device:,
                     os:,
                     scheme:,
                     tags:,
                     debug: false,
                     format: nil,
                     output: nil,
                     app:,
                     profile:,
                     quiet: false,
                     timeout:,
                     ios_uuid: nil)
      if debug
        Logger.level = ::Logger::DEBUG
        Logger.formatter = proc do |serverity, time, _progname, msg|
          "\n#{time}\t#{serverity}\t#{msg.rstrip}"
        end
      end

      # Update the plist
      # update_plist(scheme, app.app_path)

      # Update the appium.txt file
      create_appium_txt(app: app.app_path, device_name: device, platform_version: os, timeout: timeout)

      # start the appium server
      if @ios_uuid
        app_server = AppiumServer.new(ios_uuid: ios_uuid)
      else
        app_server = AppiumServer.new
      end
      app_server.start_server

      # Run the tests
      run_tests(tags: tags, profile: profile, format: format, output: output, quiet: quiet)

      # Stop the Appium server
      # app_server.stop_server
    end # execute

    #
    # Run the cucumber tests, that's why we're here afterall
    #
    # @param ios [String] The iOS version to test with
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
    def self.create_appium_txt(platform_name: 'iOS', device_name:, platform_version:, app:, timeout:)
      appium = AppiumText.new(platform_name: platform_name,
                              device_name: device_name,
                              platform_version: platform_version,
                              app: app,
                              new_command_timeout: timeout)
      appium.execute
    end
  end # class Command
end # module Cuesmash
