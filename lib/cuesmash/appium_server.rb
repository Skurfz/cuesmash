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
    def initialize
    end

    #
    # Run the appium server
    #
    def start_server
      started

      command = 'appium --log-level debug'

      @stdin, @stdout, @stderr, @wait_thr = Open3.popen3(command)
      Logger.info "Appium running with pid: #{@wait_thr.pid}"

      if Logger.debug?
        [@stdout, @stderr].each do |stream|
          Thread.new do
            until (line = stream.gets).nil?
              Logger.debug line
            end
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
      Logger.info 'Starting Appium Server'
    end

    #
    # Output a nice message for completing
    #
    def completed
      Logger.info 'Stopping Appium server 👌'
    end
  end
end
