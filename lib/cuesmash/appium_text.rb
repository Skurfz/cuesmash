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
    def initialize(platform_name, device_name, platform_version, app)
      @platform_name = platform_name
      @device_name = device_name
      @platform_version = platform_version
      @app = app
    end

    def execute
      started
      update
      completed
    end


    private

    def started
      puts "\nUpdating appium.txt"
      puts "==================="
    end

    def update
      text = file_text
      IO.write("features/support/appium.txt", text)
    end

    def completed
      puts "appium.txt updated 👌"
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
      text << "platformVersion = \"#{platform_version}\"\n"
      text << "app = \"#{app}\"\n"
      text
    end
  end
end
