#!/usr/bin/env ruby
# coding: utf-8

module Cuesmash

  #
  # Does some fun stuff with Xcode plists, cuesmash needs to update
  # the Xcode projects plist to trick the simulator into connecting
  # to a sinatra server instead
  #
  # @author [alexfish]
  #
  class Plist
    include Logging

    # Public: the Scheme the plist is related to
    attr_accessor :scheme
    attr_accessor :tmp_dir
    attr_accessor :plist_name

    #
    # Create a new plist instance
    # @param  scheme [String] The scheme related to the plist
    # @param  app_path [String] The dir where the app is going to be placed.
    # @param  plist_name [String] Default: server_config. The name of the file with the server configurations.
    #
    # @return [Plist] A plist instance
    def initialize(scheme, app_path, plist_name="server_config")
      @scheme = scheme
      @tmp_dir = tmp_dir
      @plist_name = plist_name
      @app_path = app_path
    end

    #
    # Executes the plist tasks update and clear the old plists
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
      puts "\nUpdating plist"
      puts "=============="
    end

    #
    # Output a nice message for completing
    #
    def completed
      puts "Plist updated 👌"
    end

    #
    # Update the Xcode applications server.plist file
    # with sinatras port and URL
    #
    def update
      plist_file = CFPropertyList::List.new(:file => server_plist_path)
      plist = CFPropertyList.native_types(plist_file.value)

      plist["url_preference"] = server_ip
      plist["port_preference"] = Cuesmash::PORT

      plist_file.value = CFPropertyList.guess(plist)
      plist_file.save(server_plist_path, CFPropertyList::List::FORMAT_XML)
    end

    #
    # Clear the existing plist from the iOS simulator
    #
    def clear
      FileUtils.rm(simulator_plist_path, :force => true)
    end

    #
    # The local IP address of the mock backend server
    #
    # @return [String] The mock backends IP
    def server_ip
      Socket.ip_address_list.find {|a| a.ipv4? && !a.ipv4_loopback?}.ip_address
    end

    #
    # The path to the iOS simulators plist
    #
    # @return [String] The path to the plist
    def simulator_plist_path
      "#{File.expand_path('~')}/Library/Preferences/com.apple.iphonesimulator.plist"
    end

    #
    # The path to the server config plist
    #
    # @return The full path to the server config plist
    def server_plist_path
      @app_path + "/#{@plist_name}.plist"
    end

  end
end
