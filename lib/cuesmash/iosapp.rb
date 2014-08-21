#!/usr/bin/env ruby
# coding: utf-8

module Cuesmash

  #
  # Provides an object to get information about the ios app that is being built.
  #
  # @author [jarod]
  #
  class IosApp

    # Public: the path to the dir containing the built app i.e. /tmp/MyAppQWERQW/Build/Products/Debug-iphonesimulator/
    attr_reader :app_dir

    # Public: the full path including the built app i.e. /tmp/MyAppQWERQW/Build/Products/Debug-iphonesimulator/MyApp.app"
    attr_reader :app_path

    # Public: the app name i.e. MyApp.app
    attr_reader :app_name

    # Public: the xcode Derived Data temp directory
    attr_reader :tmp_dir

    #
    # Create a new App instance
    #
    # @param  file_name [String] The usually is the scheme of the xcode project
    #
    # @return [App] A app instance
    def initialize(file_name:)
      @app_name = "#{file_name}" << ".app"
      @tmp_dir = Dir.mktmpdir(file_name)
      @app_dir = "#{@tmp_dir}" << "/Build/Products/Debug-iphonesimulator/"
      @app_path = "#{@app_dir}" << "#{@app_name}"
    end
  end
end
