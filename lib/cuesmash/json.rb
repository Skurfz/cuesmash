#!/usr/bin/env ruby
# coding: utf-8

module Cuesmash
  #
  # Does some fun stuff with Xcode jsons, cuesmash needs to update
  # the Xcode projects json to trick the simulator into connecting
  # to a sinatra server instead
  #
  # @author [jarod]
  #
  class JsonConf
    # include Logging

    # Public: the Scheme the json is related to
    attr_accessor :scheme
    attr_accessor :tmp_dir
    attr_accessor :file_name

    #
    # Create a new json instance
    # @param  scheme [String] The scheme related to the json
    # @param  app_path [String] The dir where the app is going to be placed.
    # @param  file_name [String] Default: server_config. The name of the file with the server configurations.
    #
    # @return [JsonConf] A JsonConf instance
    def initialize(scheme:, app_path:, file_name: 'server_config')
      @scheme = scheme
      @tmp_dir = tmp_dir
      @file_name = file_name
      @app_path = app_path
    end

    #
    # Executes the json tasks update and clear the old jsons
    #
    def execute
      started
      update
      clear

      completed
    end

    private

    #
    # Output a nice message for starting
    #
    def started
      Logger.info 'Updating json'
    end

    #
    # Output a nice message for completing
    #
    def completed
      Logger.info 'json updated 👌'
    end

    #
    # Update the Xcode applications server.json file
    # with sinatras port and URL
    #
    def update
      # create the json file
    end

    #
    # The local IP address of the mock backend server
    #
    # @return [String] The mock backends IP
    def server_ip
      Socket.ip_address_list.find { |a| a.ipv4? && !a.ipv4_loopback? }.ip_address
    end

    #
    # The path to the server config json
    #
    # @return [String] The full path to the server config json
    def server_json_path
      @app_path + "/#{@file_name}.json"
    end
  end # class json
end
