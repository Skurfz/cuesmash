#!/usr/bin/env ruby
# coding: utf-8

module Cuesmash
  #
  # Provides a nice interface to cucumber, allowing
  # us to run the cucumber test suite
  #
  # @author [alexfish]
  #
  class Cucumber
    # Public: the output directory for the tests
    attr_accessor :output

    # Public: the output format for the tests
    attr_accessor :format

    # Public: the cucumber profile to use for the tests
    attr_accessor :profile

    # Public: the cucumber quiet flag
    attr_accessor :quiet

    #
    # Create a new instance of Cucumber
    # @param  ios [String] The iOS version cucumber will run
    # @param  tags [Array] The tags cucumber will run with
    # @param profile [String] the cucumber profile to use for the tests
    # @param quiet [Boolean]
    #
    def initialize(tags, profile, quiet)
      @tags = tags
      @profile = profile
      @quiet = quiet
    end

    #
    # Run the cucumber tests
    #
    def test
      started

      status = nil

      stdin, stdout, stderr, wait_thr = Open3.popen3(command)
      Logger.info "cucumber running with pid: #{wait_thr.pid}"
      [stdout, stderr].each do |stream|
        Thread.new do
          until (line = stream.gets).nil?
            Logger.info "[Cucumber] #{line}"
          end
        end
      end

      wait_thr.join
      status = wait_thr.value.exitstatus

      if status != 0
        Logger.info 'Cucumber failed'
        status
      else
        completed
      end
    end

    private

    #
    # Output a nice message for starting
    #
    def started
      Logger.info 'Running Cucumber'
    end

    #
    # Output a nice message for completing
    #
    def completed
      Logger.info 'Cucumber Completed 👌'
    end

    #
    # Figure out what the cucumber command is and
    # return it
    #
    # @return [String] The cucumber command string
    def command
      command_string = 'cucumber'
      command_string += " --format #{format}" if format
      command_string += " --out #{output}" if output
      command_string += " --profile #{profile}" if profile
      command_string += @tags.to_a.empty? ? '' : tag_arguments
      command_string += ' --quiet' if quiet
      command_string += ' -c'

      Logger.debug "cucumber command == #{command_string}"

      command_string
    end

    #
    # Generate the --tags arguments for the cucumber
    # command
    #
    # @return [String] The --tags commands ready to go
    def tag_arguments
      command_tag = ''
      @tags.each do |tag_set|
        command_tag = '' unless command_tag
        command_tag += " --tags #{tag_set}"
      end

      command_tag
    end
  end
end
