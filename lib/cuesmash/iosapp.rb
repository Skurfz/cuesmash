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
    # @param travis_build [Boolean] if the build is running on travis-ci
    # @param build_configuration [String] which iOS build configuration to run i.e. Release, Debug
    #
    # @return [App] A app instance
    def initialize(file_name:, travis_build: false, build_configuration:)
      @app_name = "#{file_name}" << ".app"
      @tmp_dir = Dir.mktmpdir(file_name)
      @build_configuration = build_configuration

      # if we are running this on travis then we want to build inside the project
      # dir (it's a VM so it gets cleaned up each run). Otherwise let's create
      # our own tmp dir for each build.
      if travis_build
        @app_dir = "./build/Release-iphonesimulator/"
      else
        @app_dir = "#{@tmp_dir}" << "/#{@build_configuration}-iphonesimulator/"
      end
      @app_path = "#{@app_dir}" << "#{@app_name}"
    end
  end
end
