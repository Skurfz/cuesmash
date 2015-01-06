#!/usr/bin/env ruby
# coding: utf-8

module Cuesmash

  #
  # Provides an object to get information about the ios app that is being built.
  #
  class AndroidApp < App

    # app/build/outputs/apk/
    attr_reader :app_dir

    # Public: the full path including the built app i.e. ./app/build/outputs/apk/app-debug.apk"
    attr_reader :app_path

    # Public: the app name i.e. app-debug.apk
    attr_reader :app_name

    #
    # Create a new App instance
    #
    # @param  project_name [String] the project name to be built.
    # @param build_configuration [String] which build configuration to run i.e. Release, Debug
    #
    # @return [App] A app instance
    def initialize(project_name:, build_configuration:)
      @app_name = "#{project_name}-#{build_configuration}" << ".apk"

      @app_dir = File.expand_path("./app/build/outputs/apk/")
  
      @app_path = "#{@app_dir}/" << "#{@app_name}"
    end

  end # class AndroidApp
end # module Cuesmash