#!/usr/bin/env ruby
# coding: utf-8

module Cuesmash
  #
  # Creates the appium.txt file that is needed by appium
  #
  # @author [jarod]
  #
  class AndroidAppiumText
    attr_accessor :appium_avd
    attr_accessor :appium_app
    attr_accessor :appium_platform_name
    attr_accessor :appium_new_command_timeout
    attr_accessor :appium_text_for_file

    #
    # [initialize description]
    # @param platform_name: [type] [description]
    # @param avd: [type] [description]
    # @param app: [type] [description]
    # @param new_command_timeout: 60 [type] [description]
    #
    # @return [type] [description]
    def initialize(platform_name:, avd:, app:, new_command_timeout: 60)
      @appium_platform_name = platform_name
      @appium_avd = avd
      @appium_app = app
      @appium_new_command_timeout = new_command_timeout
    end

    def execute
      started
      update
      completed
    end

    private

    def started
      Logger.info 'Updating appium.txt'
    end

    def update
      @appium_text_for_file = file_text
      IO.write('features/support/appium.txt', @appium_text_for_file)
    end

    def completed
      Logger.info 'appium.txt updated 👌'
    end

    # [caps]
    # platformName = "Android"
    # app = "/Users/admin/repos/android-bbd-sample/app/build/outputs/apk/app-debug.apk"
    # newCommandTimeout = "130"
    # avd = "Nexus_6_API_21"
    def file_text
      text = "[caps]\n"
      text << "platformName = \"#{appium_platform_name}\"\n"
      text << "deviceName = \"Android Emulator\"\n"
      if appium_avd == ''
      text << "avd = \"#{appium_avd}\"\n"
      end
      text << "app = \"#{appium_app}\"\n"
      text << "newCommandTimeout = \"#{appium_new_command_timeout}\"\n"
      Logger.debug "appium.text == #{text}"
      text
    end
  end
end
