#!/usr/bin/env ruby
# coding: utf-8

module Cuesmash

  #
  # Creates the appium.txt file that is needed by appium
  #
  # @author [jarod]
  #
  class AppiumText

    attr_accessor :platform_version
    attr_accessor :app
    attr_accessor :platform_name
    attr_accessor :device_name
    attr_accessor :new_command_timeout
    attr_accessor :appium_text_for_file

    #
    # Create a new appium_text instance. These params are based off the appium.txt
    # [caps] format.
    #
    # @param  platform_name [String] The platform_name platformName = "iOS"
    # @param  device_name [String] deviceName = "iPhone Simulator"
    # @param  platform_version [String] platformVersion = "7.1"
    # @param  app [String] path to built .app file
    #
    # @return [AppiumText] A appiumtext instance
    def initialize(platform_name:, device_name:, platform_version: nil, app:, new_command_timeout: 60)
      @platform_name = platform_name
      @device_name = device_name
      @platform_version = platform_version
      @app = app
      @new_command_timeout = new_command_timeout
    end

    def execute
      started
      update
      completed
    end

    private

    def started
      Logger.info "Updating appium.txt"
    end

    def update
      @appium_text_for_file = file_text
      IO.write("features/support/appium.txt", @appium_text_for_file)
    end

    def completed
      Logger.info "appium.txt updated 👌"
    end

    # [caps]
    # platformName = "iOS"
    # deviceName = "iPhone Simulator"
    # platformVersion = "7.1"
    # app = "/Users/jarod/Library/Developer/Xcode/DerivedData/laterooms-fnlioqzgtpowdmezkwdzsyicgjiz/Build/Products/Debug-iphonesimulator/laterooms.app"
    def file_text
      text = "[caps]\n"
      text << "platformName = \"#{platform_name}\"\n"
      text << "deviceName = \"#{device_name}\"\n"
      text << "platformVersion = \"#{platform_version}\"\n" unless platform_version == nil
      text << "app = \"#{app}\"\n"
      text << "newCommandTimeout = \"#{new_command_timeout}\"\n"
      Logger.debug "appium.text == #{text}"
      text
    end
  end
end
