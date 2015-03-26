#!/usr/bin/env ruby
# coding: utf-8

module Cuesmash
  #
  # Provides an object to get information about the ios app that is being built
  #
  class App
    # Public: the xcode Derived Data temp directory
    attr_reader :tmp_dir

    #
    # Create a new App instance
    #
    # @return [App] A app instance
    def initialize
      @tmp_dir = Dir.mktmpdir(file_name)
    end
  end
end
