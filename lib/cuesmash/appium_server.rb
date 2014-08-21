#!/usr/bin/env ruby
# coding: utf-8

module Cuesmash

  #
  # Provides an interface for starting the appium server
  #
  # @author [jarod]
  #
  class AppiumServer

    # Public: the output directory for the tests
    attr_accessor :output

    # Public: the output format for the tests
    attr_accessor :format

    #
    # Create a new instance of AppiumServer
    #
    def initialize()
    end

    #
    # Run the appium server
    #
    def start_server
      started
      @stdin, @stdout, @stderr, @wait_thr = Open3.popen3("appium --log-level info")
      puts "Appium running with pid: #{@wait_thr.pid}"

      # put this inside a debug flag
      [@stdout, @stderr].each do |stream|
        Thread.new do
          until (line = stream.gets).nil? do
            puts line
          end
        end
      end
    end

    #
    # Stop the appium server
    #
    def stop_server
      Process.kill('INT', @wait_thr.pid)
      @stdin.close
      @stdout.close
      @stderr.close

      completed
    end

    private

    #
    # Output a nice message for starting
    #
    def started
      puts "\nStarting Appium Server"
      puts "======================\n"
    end

    #
    # Output a nice message for completing
    #
    def completed
      puts "\nStopping Appium server 👌"
    end

    #
    # Figure out what the cucumber command is and
    # return it
    #
    # @return [String] The cucumber command string
    def command
      command = "appium"
      command
    end
  end
end
