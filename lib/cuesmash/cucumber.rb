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

    #
    # Create a new instance of Cucumber
    # @param  ios [String] The iOS version cucumber will run
    # @param  tags [Array] The tags cucumber will run with
    # @param profile [String] the cucumber profile to use for the tests
    #
    def initialize(ios, tags, profile)
      @ios = ios
      @tags = tags
      @profile = profile
    end

    #
    # Run the cucumber tests
    #
    def test
      started

      status = nil
      output = ""

      cucumber_command = command
      Logger.debug "cucumber_command == #{cucumber_command}"

      Open3.popen3 cucumber_command do |stdin, out, err, wait_thr|

        [out, err].each do |stream|
          Thread.new do
            until (line = stream.gets).nil? do
              Logger.info line
            end
          end
        end

        wait_thr.join
        status = wait_thr.value.exitstatus
      end

      if status != 0
        Logger.info "Cucumber failed"
        # exit status
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
      Logger.info "Running Cucumber"
    end

    #
    # Output a nice message for completing
    #
    def completed
      Logger.info "Cucumber Completed 👌"
    end

    #
    # Figure out what the cucumber command is and
    # return it
    #
    # @return [String] The cucumber command string
    def command
      command_string = "cucumber"
      command_string += " --format #{self.format}" if self.format
      command_string += " --out #{self.output}" if self.output
      command_string += " --profile #{self.profile}" if self.profile
      command_string += @tags.to_a.empty? ? "" : tag_arguments
      command_string += " -c"

      Logger.debug "cucumber command == #{command_string}"

      command_string
    end

    #
    # Generate the --tags arguments for the cucumber
    # command
    #
    # @return [String] The --tags commands ready to go
    def tag_arguments
      command_tag = ""
      @tags.each do |tag_set|
        command_tag = "" unless command_tag
        command_tag += " --tags #{tag_set}"
      end

      command_tag
    end
  end
end
