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

    class << self

      #
      # Execute a command with some arguments
      # then figure out what we're supposed to be doing with
      # the arguments
      #
      # @param device [String]
      # @param os [String]
      # @param server [String]
      # @param tags [Array]
      # @param scheme [String]
      # @param debug [Boolean]
      # @param format [String]
      # @param output [String]
      # @param travis [Boolean]
      # @param app [IosApp Object]
      #
      # @return [type] [description]
      def execute(device:, os:, server:, tags:, scheme:, debug: false, format: nil, output: nil, travis: nil, app:)

        if debug
          Logger.level = ::Logger::DEBUG
          Logger.formatter = proc do |serverity, time, progname, msg|
            "\n#{time}\t#{serverity}\t#{msg.rstrip}"
          end
        end

        # Update the plist
        # update_plist(scheme, app.app_path)

        # Update the appium.txt file
        create_appium_txt(app: app.app_path, device_name: device, platform_version: os)

        # start the appium server
        app_server = AppiumServer.new
        app_server.start_server

        # Run the tests
        run_tests(os, tags, format, output)

        # Stop the Appium server
        # app_server.stop_server

      end # execute

      #
      # Update the applications plist so that the application
      # connects to sinatra
      #
      # @param scheme [String] The scheme related to the application
      # @param app_path [String] The path to the app
      #
      def update_plist(scheme, app_path)
        plist = Cuesmash::Plist.new(scheme, app_path)
        plist.execute
      end

      #
      # Run the cucumber tests, that's why we're here afterall
      #
      # @param ios [String] The iOS version to test with
      # @param tags [Array] The cucumber tags to test with
      # @param format [String] The output format for the cucumber tests, Optional
      # @param output [String] The path to the output directory to output test reports to, Optional
      #
      def run_tests(ios, tags, format=nil, output=nil)
        cucumber = Cuesmash::Cucumber.new(ios, tags)
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
      #
      def create_appium_txt(platform_name: "iOS", device_name:, platform_version:, app:)
        appium = AppiumText.new(platform_name: platform_name, device_name: device_name, platform_version: platform_version, app: app)
        appium.execute
      end
    end
  end
end
