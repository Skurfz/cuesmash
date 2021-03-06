#!/usr/bin/env ruby
# coding: utf-8

require 'cuesmash/app'

module Cuesmash
  #
  # Provides an object to get information about the ios app that is being built.
  #
  class IosApp < App
    # Public: the path to the dir containing the built app i.e. /tmp/MyAppQWERQW/Build/Products/Debug-iphonesimulator/
    attr_reader :app_dir

    # Public: the full path including the built app
    # i.e. /tmp/MyAppQWERQW/Build/Products/Debug-iphonesimulator/MyApp.app"
    attr_reader :app_path

    # Public: the app name i.e. MyApp.app
    attr_reader :app_name

    # Public: the xcode Derived Data temp directory
    attr_reader :tmp_dir

    #
    # Create a new App instance
    #
    # @param [String] file_name: This usually is the scheme of the xcode project
    # @param [String] build_configuration: which iOS build configuration to run i.e. Release, Debug
    # @param [String] app_name: name of the app
    # @param [String] device: nil the UDID of the device to run on or nil if running on simulator
    #
    def initialize(file_name:, build_configuration:, app_name:, device: nil)
      app_name = file_name if app_name.nil?

      @app_name = "#{app_name}" << '.app'
      @tmp_dir = Dir.mktmpdir(app_name)
      @build_configuration = build_configuration

      if device.nil?
        @app_dir = "#{@tmp_dir}" << "/#{@build_configuration}-iphonesimulator/"
      else
        @app_dir = "#{@tmp_dir}" << "/#{@build_configuration}-iphoneos/"
      end

      @app_path = "#{@app_dir}" << "#{@app_name}"
    end
  end # class IosApp
end # module Cuesmash
